import 'package:flutter/foundation.dart';
import 'package:husa_app/models/mtp_data.dart';

import '../models/user.dart';

class AppReadyAction {}

class SaveProductListsAction {}

class UpdateUserAction {
  User user;

  UpdateUserAction({@required this.user});
}

class UpdateUserSsnAction {
  String ssn;

  UpdateUserSsnAction({@required this.ssn});
}

class UpdateMtpDataAction {
  MtpData mtpData;

  UpdateMtpDataAction({ @required this.mtpData });
}