import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String username;
  final String ssn;
  final String token;

  User({
    @required this.name,
    @required this.username,
    @required this.ssn,
    @required this.token,
  });

  User copyWith({String name, String username, String ssn, String token}) {
    return User(
      name: name ?? this.name,
      username: username ?? this.name,
      ssn: ssn ?? this.ssn,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["name"] = name;
    jsonMap["username"] = username;
    jsonMap["ssn"] = ssn;
    jsonMap["token"] = token;
    return jsonMap;
  }

  static User fromJsonObject(Map<String, dynamic> jsonObject) {
    return User(
      name: jsonObject["name"],
      username: jsonObject["username"],
      ssn: jsonObject["ssn"],
      token: jsonObject["token"]
    );
  }
}