import 'package:flutter/material.dart';

class ErrorHandler extends StatelessWidget {
  final String error;
  ErrorHandler({@required this.error});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        RaisedButton(
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.grey.shade700,
          child: Text(
            'Indietro',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      title: Text('Si è verificato un errore!'),
      content: Text(error),
    );
  }
}
