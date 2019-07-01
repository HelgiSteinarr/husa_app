import 'package:flutter/material.dart';

class SearchBarButton extends StatelessWidget {
  SearchBarButton({Key key, this.onTap, this.icon, this.enabled = true}) : super(key: key);

  final Function onTap;
  final IconData icon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          enableFeedback: enabled,
          child: Container(
            child: Center(
              child: Icon(
                icon,
                color: (enabled) ? Colors.black : Colors.black54,
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
