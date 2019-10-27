import 'package:flutter/foundation.dart';
import 'package:husa_app/models/history_item.dart';

class MtpData {
  final String ssn;
  final List<HistoryItem> historyItems;

  MtpData({
    this.ssn,
    this.historyItems,
  });
}