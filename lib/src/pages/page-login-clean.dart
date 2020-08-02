import 'package:flutter/material.dart';
import '../global/config.dart';
import '../global/enum.dart';

class LoginCleanPage extends StatefulWidget {
  //final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  _LoginCleanPageState createState() => _LoginCleanPageState();
}

class _LoginCleanPageState extends State<LoginCleanPage> {
  AuthMode _authMode = AuthMode.LOGIN;

  InputDecoration formFieldDecoration = InputDecoration(
    alignLabelWithHint: true,
    hintStyle: TextStyle(color: Colors.white),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            tileMode: TileMode.repeated,
            colors: [Colors.black, Colors.grey.shade800]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(Config.dh * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                _logo(),
                SizedBox(height: Config.dh * 0.05),
                _loginFormField(),
                SizedBox(height: Config.dh * 0.03),
                _otherAuthenticationMethods(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
        margin: EdgeInsets.fromLTRB(0, Config.dh * 0.05, 0, 0),
        height: Config.dh * 0.20,
        // logo
        child: Container());
  }

  Widget _loginFormField() {
    return Container(
        child: Form(
      //key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _emailTextField(),
          SizedBox(height: Config.dh * 0.04),
          _passwordTextField(),
          _authMode == AuthMode.LOGIN
              ? SizedBox(height: Config.dh * 0.025)
              : SizedBox(height: Config.dh * 0.04),
          _authMode == AuthMode.LOGIN
              ? Container()
              : _confirmPasswordTextField(),
          _authMode == AuthMode.SIGNIN
              ? SizedBox(height: Config.dh * 0.02)
              : Container(),
          _toggleAuthMode(),
          SizedBox(height: Config.dh * 0.02),
          _loginSubmitButton(),
        ],
      ),
    ));
  }

  Widget _emailTextField() {
    return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: formFieldDecoration.copyWith(hintText: 'Username'));
  }

  Widget _passwordTextField() {
    return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration: formFieldDecoration.copyWith(hintText: 'Password'));
  }

  Widget _confirmPasswordTextField() {
    return TextFormField(
        style: TextStyle(color: Colors.white),
        decoration:
            formFieldDecoration.copyWith(hintText: 'Conferma Password'));
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
            color: Colors.white, decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _loginSubmitButton() {
    return MaterialButton(
      elevation: 10.0,
      onPressed: () {},
      child: Container(
        width: Config.dw * 0.6,
        height: Config.dh * 0.07,
        decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(5.0)),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }

  Widget _otherAuthenticationMethods() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, Config.dh * 0.04, 0, 0),
      padding: EdgeInsets.symmetric(
          horizontal: Config.dw * 0.01, vertical: Config.dh * 0.01),
      decoration: BoxDecoration(
          color: Colors.grey.shade800, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            child: Image.asset('assets/google.png'),
          ),
          SizedBox(width: Config.dw * 0.1),
          Container(
            height: 60,
            child: Image.asset('assets/facebook.png'),
          ),
          SizedBox(width: Config.dw * 0.1),
          Container(
            height: 50,
            child: Image.asset('assets/twitter.png'),
          )
        ],
      ),
    );
  }
}
