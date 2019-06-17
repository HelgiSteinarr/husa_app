import 'package:intl/intl.dart';

String fromatPrice(int price) {
  var numberFormat = NumberFormat.currency(locale: "is_IS", name: "kr", decimalDigits: 0);
  return numberFormat.format(price);
}