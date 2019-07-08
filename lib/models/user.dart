import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String username;
  final String token;

  User({
    @required this.name,
    @required this.username,
    @required this.token,
  });
}