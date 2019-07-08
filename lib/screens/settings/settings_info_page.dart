import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          /*Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: SvgPicture.asset(
                    "assets/icons/husa_icon.svg",
                    height: 80.0,
                    width: 80.0,
              )),
              Padding(
                padding: EdgeInsets.all(5.0),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Húsasmiðjan",
                    style: TextStyle(fontSize: 30.0),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Útgáfa 0.1",
                    style: TextStyle(
                      color: Colors.black54
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                  )
                ],
              ),
            ],
          ),*/
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
