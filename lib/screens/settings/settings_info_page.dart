import 'package:flutter/material.dart';

class SettingsInfoPage extends StatelessWidget {
  SettingsInfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Um appið"),
      ),
      body: Column(
        children: <Widget>[
          // TODO: Add about text
          Text("Um appið....."),
          Padding(
            padding: EdgeInsets.all(10.0),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "© 2019 Guðmundur Óli Halldórsson.  Allur réttur áskilinn",
              style: TextStyle(
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
