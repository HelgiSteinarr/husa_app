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

  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["name"] = name;
    jsonMap["username"] = username;
    jsonMap["token"] = token;
    return jsonMap;
  }

  static User fromJsonObject(Map<String, dynamic> jsonObject) {
    return User(
      name: jsonObject["name"],
      username: jsonObject["username"],
      token: jsonObject["token"]
    );
  }
}