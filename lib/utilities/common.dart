import 'package:intl/intl.dart';

class FileDoesNotExistException implements Exception {
  String cause;
  FileDoesNotExistException(this.cause);
}

String fromatPrice(int price) {
  var numberFormat = NumberFormat.currency(locale: "is_IS", name: "kr", decimalDigits: 0);
  return numberFormat.format(price);
}