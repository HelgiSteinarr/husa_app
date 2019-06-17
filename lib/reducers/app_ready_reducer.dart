import 'package:husa_app/actions/app_actions.dart';
import '../models/app_state.dart';

bool appReadyReducer(bool appReady, action) {
  if (action is AppReadyAction) {
    return true;
  } else {
    return appReady;
  }
}