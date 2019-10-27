import 'package:flutter/foundation.dart';
import '../actions/history_item_actions.dart';
import '../actions/app_actions.dart';
import '../models/mtp_data.dart';

MtpData mtpDataReducer(MtpData currentMtpData, action) {
  if (action is UpdateMtpDataAction) {
    return action.mtpData;
  } else if (action is UpdateHistoryBoxItemsAction) {
    return MtpData(
      ssn: currentMtpData.ssn,
      historyItems: action.historyItems,
    );
  }
  return currentMtpData;
}
