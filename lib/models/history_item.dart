import 'package:flutter/foundation.dart';

class HistoryItem {
  final String time;
  final String name;
  final String state;

  HistoryItem({
    @required this.time,
    @required this.name,
    @required this.state,
  });
}