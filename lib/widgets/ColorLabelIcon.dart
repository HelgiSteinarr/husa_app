import 'package:flutter/material.dart';
import '../models/product_list.dart';

class ColorLabelIcon extends StatelessWidget {
  ColorLabelIcon({Key key, this.label}) : super(key: key);

  final ColorLabel label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.0,
      height: 26.0,
      decoration: BoxDecoration(
        color: ColorLabel.labelColors[label.colorIndex],
        shape: BoxShape.circle,
      ),
    );
  }
}