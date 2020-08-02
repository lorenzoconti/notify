import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../global/enum.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  FirebaseUser _user;
  GoogleSignInAccount _googleAccount;

  String currentError = '';

  Status _status = Status.UNAUTHENTICATED;

  Auth.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.UNAUTHENTICATED;
    } else {
      _user = firebaseUser;
      _status = Status.AUTHENTICATED;
    }
    notifyListeners();
  }

  FirebaseUser get user {
    return _user;
  }

  Status get status {
    return _status;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser currentUser = await _firebaseAuth.currentUser();

    print(
        'USER INFO --------------------------------------------------------------------------------');
    print('Provider:' + currentUser.providerId);
    //print('Display Name:' + currentUser.displayName.toString());
    print('Email:' + currentUser.email.toString());
    print('Email Verified:' + currentUser.isEmailVerified.toString());
    print('Provider Data:' + currentUser.providerData.toString());
    print(
        '-------------------------------------------------------------------------------------------');
    return currentUser.uid;
  }

  Future<bool> signIn(Map<String, dynamic> data, AuthMode mode) async {
    _status = Status.AUTHENTICATING;
    notifyListeners();

    String email = data['email'];
    String password = data['password'];
    try {
      if (mode == AuthMode.LOGIN) {
        await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((result) {
          _user = result.user;
        });
        print(_user);
        _status = Status.AUTHENTICATED;
        notifyListeners();
        return Future.value(true);
      }
      if (mode == AuthMode.SIGNIN) {
        await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((result) {
          _user = result.user;
        });
        print(_user);
        return Future.value(true);
      }
    } catch (e) {
      print('ERROR SIGN IN/UP: ' + e.toString());
      _status = Status.UNAUTHENTICATED;
      currentError = e.toString();
      notifyListeners();
      return Future.value(false);
    }
  }

  Future<bool> signInWithProvider() async {
    if (_googleAccount == null) {
      try {
        _googleAccount = await _googleSignIn.signIn();

        GoogleSignInAuthentication googleAuth =
            await _googleAccount.authentication;

        AuthCredential _credential = GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

        AuthResult _result =
            await FirebaseAuth.instance.signInWithCredential(_credential);
        _user = _result.user;

        if (_user != null) {
          _status = Status.AUTHENTICATED;
          notifyListeners();
          return Future.value(true);
        } else {
          _status = Status.UNAUTHENTICATED;
          notifyListeners();
          return Future.value(false);
        }
      } catch (e) {
        print('ERROR SIGNING IN WITH GOOGLE: ' + e.toString());
        currentError = e.toString();
        print(currentError + '-----------');
        return Future.value(false);
      }
    }
  }

  Future<bool> signOut() async {
    _googleAccount = null;
    await _googleSignIn.signOut().catchError((e) {
      print('ERROR SIGNING OUT FROM FIREBASE: ' + e.toString());
      currentError = e.toString();
      return Future.value(false);
    });
    await _firebaseAuth.signOut().catchError((e) {
      print('ERROR SIGNING OUT FROM FIREBASE: ' + e.toString());
      currentError = e.toString();
      return Future.value(false);
    });
    return Future.value(true);
  }
}
