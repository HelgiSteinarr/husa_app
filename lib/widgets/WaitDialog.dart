import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class WaitDialog extends StatefulWidget {
  WaitDialog({Key key, this.waitFor}) : super(key: key);
  
  final Future waitFor;

  @override
  _WaitDialogState createState() => _WaitDialogState();
}

class _WaitDialogState extends State<WaitDialog> {

  @override
  void initState() {
    super.initState();

    widget.waitFor.then((value) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Center(
          child: CircularProgressIndicator(),
      )), 
    );
  }
}