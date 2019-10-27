import 'package:flutter/foundation.dart';
import 'package:husa_app/models/mtp_data.dart';

import '../models/user.dart';

class AppReadyAction {}

class SaveProductListsAction {}

class UpdateUserAction {
  User user;

  UpdateUserAction({@required this.user});
}

class UpdateMtpDataAction {
  MtpData mtpData;

  UpdateMtpDataAction({ @required this.mtpData });
}