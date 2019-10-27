import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class FileDoesNotExistException implements Exception {
  String cause;
  FileDoesNotExistException(this.cause);
}

String fromatPrice(int price) {
  var numberFormat = NumberFormat.currency(locale: "is_IS", name: "kr", decimalDigits: 0);
  return numberFormat.format(price);
}

String randomString(int length) {
  const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < length; i++) {
    result += chars[rnd.nextInt(chars.length)];
  }
  return result;
}

void restartApp(BuildContext context) {
  final AppRootState state =
        context.ancestorStateOfType(const TypeMatcher<AppRootState>());
  state.restartApp();
}