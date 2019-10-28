import '../actions/app_actions.dart';
import '../models/app_state.dart';
import '../models/user.dart';

bool appReadyReducer(bool appReady, action) {
  if (action is AppReadyAction) {
    return true;
  } else {
    return appReady;
  }
}

User currentUserReducer(User currentUser, action) {
  if (action is UpdateUserAction) {
    return action.user;
  } else if (action is UpdateUserSsnAction) {
    return currentUser.copyWith(
      ssn: action.ssn,
    );
  }
  return currentUser;
}
