import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog(
      {Key key,
      this.onAccept,
      this.onDeny,
      this.title,
      this.body,
      this.cancelButtonText,
      this.confirmButtonText,
      this.warning = false})
      : super(key: key);

  Function onAccept;
  Function onDeny;
  String title;
  String body;
  String cancelButtonText = "Nei";
  String confirmButtonText = "Já";
  bool warning;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        FlatButton(
          child: Text(cancelButtonText, style: TextStyle(color: Colors.black)),
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
          onPressed: () {
            if (onDeny != null) onDeny();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(confirmButtonText,
              style: TextStyle(color: warning ? Colors.deepOrange : Colors.black)),
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
          onPressed: () {
            if (onAccept != null) onAccept();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
