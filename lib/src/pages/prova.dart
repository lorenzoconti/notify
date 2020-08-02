import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider-auth.dart';

class ProvaPage extends StatefulWidget {
  @override
  _ProvaPageState createState() => _ProvaPageState();
}

class _ProvaPageState extends State<ProvaPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('prova'),
      ),
      body: Container(
        width: 800,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text('GetCurrentUser'),
              onPressed: () {
                provider.getCurrentUser().then((utente) {
                  print(utente);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
