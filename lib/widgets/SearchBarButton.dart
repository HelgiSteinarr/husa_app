import 'package:flutter/material.dart';

class SearchBarButton extends StatelessWidget {
  SearchBarButton({Key key, this.onTap, this.icon}) : super(key: key);

  final Function onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            child: Center(
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            width: 45.0,
            height: 45.0,
          ),
          onTap: onTap,
          splashColor: Colors.black38,
        ));
  }
}
