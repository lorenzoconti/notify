import 'package:flutter/material.dart';
import '../global/config.dart';
import '../global/enum.dart';

class LoginPage extends StatefulWidget {
  //final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthMode _authMode = AuthMode.LOGIN;

  InputDecoration formFieldDecoration = InputDecoration(
    alignLabelWithHint: true,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
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
            colors: [Colors.black, Colors.blue.shade900]),
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
    return Container(height: Config.dh * 0.20, child: Container()); // logo
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
          SizedBox(height: Config.dh * 0.05),
          _passwordTextField(),
          SizedBox(height: Config.dh * 0.05),
          _authMode == AuthMode.LOGIN
              ? Container()
              : _confirmPasswordTextField(),
          _toggleAuthMode(),
          SizedBox(),
          _loginSubmitButton(),
          SizedBox(height: Config.dh * 0.02),
          Text(
            'oppure',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    ));
  }

  Widget _emailTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Config.dh * 0.02, vertical: Config.dh * 0.008),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.shade800),
      child: Center(
        child: TextFormField(
            style: TextStyle(color: Colors.grey),
            decoration: formFieldDecoration.copyWith(hintText: 'Username')),
      ),
    );
  }

  Widget _passwordTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Config.dh * 0.02, vertical: Config.dh * 0.01),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.shade800),
      child: Center(
        child: TextFormField(
            style: TextStyle(color: Colors.grey),
            obscureText: true,
            decoration: formFieldDecoration.copyWith(hintText: 'Password')),
      ),
    );
  }

  Widget _confirmPasswordTextField() {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Config.dh * 0.02, vertical: Config.dh * 0.01),
      margin: EdgeInsets.only(bottom: Config.dh * 0.05),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.grey.shade800),
      child: Center(
        child: TextFormField(
            style: TextStyle(color: Colors.grey),
            obscureText: true,
            decoration:
                formFieldDecoration.copyWith(hintText: 'Conferma Password')),
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
            color: Colors.white, decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _loginSubmitButton() {
    return Container();
  }

  Widget _otherAuthenticationMethods() {
    return Row(
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
    );
  }
}
