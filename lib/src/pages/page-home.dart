import 'package:flutter/material.dart';
import 'package:notify/src/pages/page-auth.dart';
import 'package:notify/src/pages/page-news.dart';
import 'package:notify/src/pages/page-splashscreen.dart';

import 'package:provider/provider.dart';

import '../global/enum.dart';
import '../providers/provider-auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, Auth auth, _) {
        switch (auth.status) {
          case Status.UNINITIALIZED:
            return SplashScreen();
          case Status.AUTHENTICATING:
          case Status.UNAUTHENTICATED:
            return AuthPage();
          case Status.AUTHENTICATED:
            return NewsPage();
        }
      },
    );
  }
}
