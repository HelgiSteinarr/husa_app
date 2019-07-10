import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  SimpleAlertDialog({ Key key, this.title, this.text }) : super(key: key);

  Text title;
  Text text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: text,
      actions: <Widget>[
        FlatButton(
          child: Text("Loka"),
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
