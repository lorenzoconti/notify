import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider-auth.dart';

import '../global/config.dart';
import '../global/enum.dart';

import '../widgets/error.dart';

class AuthPage extends StatefulWidget {
  //final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _authMode = AuthMode.LOGIN;
  final Map<String, dynamic> _data = {'email': null, 'password': null};

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _passwordConfirmController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  String _infoText = '';
  String _errorText = '';
  bool _anErrorHasOccured = false;

  bool _isLoading = false;
  bool _visible = false;
  bool _isLoggingWithGoogle = false;

  InputDecoration formFieldDecoration = InputDecoration(
    alignLabelWithHint: true,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
  );

  InputDecoration formFieldDecorationWithError = InputDecoration(
      alignLabelWithHint: true,
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)));

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            width: Config.dw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _logo(),
                _loginFormField(),
                _authMode == AuthMode.LOGIN
                    ? _otherAuthenticationMethods()
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
        height: Config.dh * 0.20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey.shade600.withOpacity(0.6)),
        margin: EdgeInsets.fromLTRB(Config.dh * 0.05, Config.dh * 0.08,
            Config.dh * 0.05, Config.dh * 0.04),
        padding: EdgeInsets.all(Config.dh * 0.01),
        // logo
        child: Container());
  }

  Widget _loginFormField() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade700.withOpacity(0.65),
            borderRadius: BorderRadius.circular(5.0)),
        margin: EdgeInsets.symmetric(
            horizontal: Config.dh * 0.025, vertical: Config.dh * 0.02),
        padding: EdgeInsets.all(Config.dh * 0.025),
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _emailTextField(),
              SizedBox(height: Config.dh * 0.03),
              _passwordTextField(),
              _authMode == AuthMode.LOGIN
                  ? SizedBox(height: Config.dh * 0.015)
                  : SizedBox(height: Config.dh * 0.03),
              _authMode == AuthMode.LOGIN
                  ? Container()
                  : _confirmPasswordTextField(),
              _toggleAuthMode(),
              _infoTextBox(),
              _loginSubmitButton(),
            ],
          ),
        ));
  }

  Widget _emailTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Config.dh * 0.02, vertical: Config.dh * 0.008),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey.shade500.withOpacity(0.6)),
      child: Center(
        child: TextFormField(
          controller: _emailController,
          focusNode: _emailFocusNode,
          onFieldSubmitted: (s) {
            _focusChange(context, _emailFocusNode, _passwordFocusNode);
          },
          style: TextStyle(color: Colors.white),
          decoration: _anErrorHasOccured
              ? formFieldDecorationWithError.copyWith(hintText: 'Email')
              : formFieldDecoration.copyWith(hintText: 'Email'),
          validator: (value) {
            if (value.isNotEmpty &&
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) return 'Inserire una email valida';
          },
          onSaved: (value) {
            _data['email'] = value.trim();
            _emailController..text = value;
          },
        ),
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Config.dh * 0.02, vertical: Config.dh * 0.008),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey.shade500.withOpacity(0.6)),
      child: Center(
        child: TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onFieldSubmitted: (s) {
              _focusChange(
                  context, _passwordFocusNode, _passwordConfirmFocusNode);
            },
            style: TextStyle(color: Colors.white),
            obscureText: _visible ? false : true,
            decoration: _anErrorHasOccured
                ? formFieldDecorationWithError.copyWith(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color: Colors.grey.shade300,
                      onPressed: () => _changePasswordStatus(),
                    ))
                : formFieldDecoration.copyWith(
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      color: Colors.grey.shade300,
                      onPressed: () => _changePasswordStatus(),
                    )),
            validator: (value) {
              if (value.isEmpty) return "Inserire una password.";
              if (_authMode == AuthMode.SIGNIN && value.length < 8)
                return "La password deve contenere almeno 8 caratteri";
            },
            onSaved: (value) {
              _data['password'] = value.trim();
              _passwordController..text = value;
            }),
      ),
    );
  }

  Widget _confirmPasswordTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Config.dh * 0.02, vertical: Config.dh * 0.008),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.grey.shade500.withOpacity(0.6)),
      child: Center(
        child: TextFormField(
            controller: _passwordConfirmController,
            focusNode: _passwordConfirmFocusNode,
            style: TextStyle(color: Colors.white),
            obscureText: _visible ? false : true,
            decoration: formFieldDecoration.copyWith(
                hintText: 'Conferma Password',
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  color: Colors.grey.shade300,
                  onPressed: () => _changePasswordStatus(),
                )),
            validator: (value) {
              if (value.isEmpty) return 'Inserire nuovamente la password';
              if (value != _passwordController.text)
                return 'Le password non coincidono';
            },
            onSaved: (value) {
              _passwordConfirmController..text = value;
            }),
      ),
    );
  }

  Widget _toggleAuthMode() {
    return MaterialButton(
      onPressed: () {
        setState(() {
          if (_authMode == AuthMode.LOGIN)
            _authMode = AuthMode.SIGNIN;
          else
            _authMode = AuthMode.LOGIN;
        });
      },
      child: Text(
        _authMode == AuthMode.LOGIN
            ? 'Non sei registrato? Registrati'
            : 'Sono già registrato',
        style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.underline,
            fontSize: 13),
      ),
    );
  }

  Widget _loginSubmitButton() {
    return MaterialButton(
      onPressed: () {
        _submitForm(context);
      },
      child: Container(
        height: Config.dh * 0.07,
        width: Config.dw * 0.48,
        margin: EdgeInsets.fromLTRB(Config.dw * 0.1, Config.dh * 0.02,
            Config.dw * 0.1, Config.dw * 0.01),
        decoration: BoxDecoration(
            color: Colors.grey.shade800.withOpacity(0.85),
            borderRadius: BorderRadius.circular(5.0)),
        child: _isLoading
            ? Container(
                margin: EdgeInsets.symmetric(
                    horizontal: Config.dh * 0.012, vertical: Config.dh * 0.01),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ))
            : Center(
                child: Text(
                    _authMode == AuthMode.LOGIN ? 'Login' : 'Registrati',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ),
      ),
    );
  }

  Widget _otherAuthenticationMethods() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade700.withOpacity(0.65),
          borderRadius: BorderRadius.circular(5.0)),
      margin: EdgeInsets.symmetric(
          vertical: Config.dh * 0.02, horizontal: Config.dh * 0.065),
      padding: EdgeInsets.all(Config.dh * 0.025),
      child: Column(
        children: <Widget>[
          /*  Text(
            'oppure',
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          SizedBox(height: Config.dh*0.01,), */
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _isLoggingWithGoogle
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : _authMethodButton(
                      'assets/google.png', 'Accedi con Google', 23),
              //_authMethodButton('assets/facebook.png', 'Facebook', 30)
            ],
          )
        ],
      ),
    );
  }

  Widget _authMethodButton(String image, String name, double size) {
    var _auth = Provider.of<Auth>(context);
    return MaterialButton(
      onPressed: () {
        if (mounted) {
          setState(() {
            _isLoggingWithGoogle = true;
          });
        }
        _auth.signInWithProvider().then((success) {
          if (success) {
            if (mounted) Navigator.of(context).pushReplacementNamed('/news');
          } else {
            if (_showErrorDialog(_auth.currentError)) {
              if (mounted) {
                setState(() {
                  _isLoggingWithGoogle = false;
                });
              }
              return showDialog(
                  context: context,
                  builder: (context) => ErrorHandler(
                        error: _errorText,
                      ));
            } else {
              setState(() {
                _isLoggingWithGoogle = false;
                _anErrorHasOccured = true;
              });
            }
          }
        });
      },
      child: Container(
        height: Config.dh * 0.08,
        //width: Config.dw * 0.33,
        decoration: BoxDecoration(
          color: Colors.grey.shade500.withOpacity(0.65),
          borderRadius: BorderRadius.circular(5.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: Config.dh * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(image), height: size),
            SizedBox(width: Config.dw * 0.035),
            Text(
              name,
              style: TextStyle(color: Colors.white, fontSize: 13),
            )
          ],
        ),
      ),
    );
  }

  void _focusChange(BuildContext context, FocusNode current, FocusNode next) {
    if (!(_authMode == AuthMode.LOGIN && current == _passwordFocusNode)) {
      current.unfocus();
      _anErrorHasOccured = false;
      FocusScope.of(context).requestFocus(next);
    }
  }

  void _submitForm(BuildContext context) {
    if (!_key.currentState.validate()) {
      print('ERROR: FORM VALIDATION FAILED');
      return;
    }

    _key.currentState.save();

    var _auth = Provider.of<Auth>(context);
    setState(() {
      _isLoading = true;
    });
    _auth.signIn(_data, _authMode).then((success) {
      if (success)
        Navigator.of(context).pushReplacementNamed('/news');
      else {
        if (_showErrorDialog(_auth.currentError)) {
          setState(() {
            _isLoading = false;
          });

          return showDialog(
              context: context,
              builder: (context) => ErrorHandler(
                    error: _errorText,
                  ));
        } else {
          setState(() {
            _isLoading = false;
            _anErrorHasOccured = true;
          });
        }
      }
    });
  }

  Widget _infoTextBox() {
    return _anErrorHasOccured
        ? Container(
            margin: EdgeInsets.only(bottom: Config.dh * 0.01),
            child: Center(
              child: Text(
                _infoText,
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          )
        : Container();
  }

  void _changePasswordStatus() {
    setState(() {
      _visible = !_visible;
    });
  }

  bool _showErrorDialog(String error) {
    switch (error) {
      case 'PlatformException(FirebaseException, An internal error has occurred. [ 7: ], null)':
        {
          _errorText = 'Controlla la tua connessione';
          _infoText = '';
          _anErrorHasOccured = false;
          return true;
        }
        break;
      case 'PlatformException(ERROR_WRONG_PASSWORD, The password is invalid or the user does not have a password., null)':
        {
          _infoText = 'Email o Password sbagliati';
          _errorText = '';
          return false;
        }
        break;
      case 'PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)':
        {
          _infoText = 'Account già esistente';
          _errorText = '';
          return false;
        }
        break;
      case 'PlatformException(ERROR_USER_NOT_FOUND, There is no user record corresponding to this identifier. The user may have been deleted., null)':
        {
          _infoText = 'Account inesistente, registrati!';
          _errorText = '';
          return false;
        }
        break;
      case 'PlatformException(ERROR_TOO_MANY_REQUESTS, We have blocked all requests from this device due to unusual activity. Try again later. [ Too many unsuccessful login attempts.  Please include reCaptcha verification or try again later ], null)':
        {
          _infoText = 'Troppi tentativi, prova più tardi.';
          _errorText = '';
          return false;
        }
        break;
      case 'PlatformException(error, Given String is empty or null, null)':
        {
          _errorText = 'Controlla di aver inserito correttamente i dati';
          _infoText = '';
          _anErrorHasOccured = false;
          return true;
        }
        break;
      case "NoSuchMethodError: The getter 'authentication' was called on null.\nReceiver: null\nTried calling: authentication":
        {
          _errorText = '';
          _infoText = '';
          return false;
        }
        break;
      default:
        {
          _infoText = '';
          _anErrorHasOccured = false;
          _errorText = error;
          return true;
        }
    }
  }
}
