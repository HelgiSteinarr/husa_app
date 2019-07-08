import 'package:flutter/foundation.dart';

import '../models/user.dart';

class AppReadyAction {}

class SaveProductListsAction {}

class UpdateUserAction {
  User user;

  UpdateUserAction({@required this.user});
}