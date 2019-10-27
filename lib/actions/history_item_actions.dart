import 'package:flutter/foundation.dart';
import '../models/history_item.dart';

class UpdateHistoryBoxItemsAction {
  List<HistoryItem> historyItems;

  UpdateHistoryBoxItemsAction({
    @required this.historyItems,
  });
}