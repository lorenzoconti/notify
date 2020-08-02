import 'package:flutter/material.dart';

import 'package:notify/src/providers/provider-news.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './src/pages/page-contact.dart';

import 'package:notify/src/providers/provider-auth.dart';

import './src/pages/page-home.dart';
import './src/pages/prova.dart';

import './src/pages/page-news.dart';

void main() => runApp(Notify());

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  String textValue = 'HelloWorld';
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _isInit = false;

  @override
  void initState() {
    _firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print(" onLaunch called");
    }, onResume: (Map<String, dynamic> msg) {
      print(" onResume alled");
    }, onMessage: (Map<String, dynamic> msg) {
      print(" onMessage called");
    });
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registered');
    });
    _firebaseMessaging.subscribeToTopic('news');

    _firebaseMessaging.getToken().then((token) {
      update(token);
    });

    super.initState();
  }

  void initApp() {
    if (!_isInit) {
      _isInit = true;

      // CHECK IF USER IS LOGGED IN
      var _auth = Provider.of<Auth>(context);
      _auth.getCurrentUser().then((uid) {
        if (uid != null) {
          // user logged in
          print(uid);
          Navigator.of(context).pushReplacementNamed('/news');
        }
      });
    }
  }

  void update(String token) {
    print(token);
  }

  final ThemeData darkTheme = ThemeData(
      backgroundColor: Colors.black12,
      scaffoldBackgroundColor: Colors.grey.shade900,
      primaryColor: Colors.black,
      accentColor: Colors.lightBlue[800],
      appBarTheme: AppBarTheme(
        color: Colors.grey.shade900,
      ),
      canvasColor: Colors.transparent);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: News(),
        ),
        ChangeNotifierProvider.value(
          value: Auth.instance(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notify',
        theme: darkTheme,
        routes: {
          '/': (BuildContext context) => HomePage(),
          '/news': (BuildContext context) => NewsPage(),
          '/contact': (BuildContext context) => ContactPage(),
          '/prova': (BuildContext context) => ProvaPage()
        },
      ),
    );
  }
}
