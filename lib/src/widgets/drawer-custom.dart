import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/provider-auth.dart';

import '../global/config.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context);
    return Drawer(
        elevation: 2.0,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade900),
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountEmail:
                    Text(_auth.user.email != null ? _auth.user.email : ''),
                accountName: Text(_auth.user.displayName != null
                    ? _auth.user.displayName
                    : ''),
              ),
              ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: Colors.grey,
                ),
                title: Text(
                  'News',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/news');
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.grey,
                ),
                title: Text(
                  'Contattaci',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(context, '/contact'),
              ),
              Divider(
                  color: Colors.white,
                  endIndent: Config.dw * 0.06,
                  indent: Config.dw * 0.06),
              ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.grey,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  //logout();
                  _auth.signOut().then((success) {
                    Future.delayed(Duration.zero,
                        () => Navigator.of(context).pushReplacementNamed('/'));
                  });
                },
              ),
              /* ListTile(
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.grey,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  //logout();
                  _auth.getCurrentUser();
                },
              ), */
            ],
          ),
        ));
  }
}
