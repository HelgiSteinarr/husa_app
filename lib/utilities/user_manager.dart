import 'dart:io';
import 'dart:convert';
import 'package:husa_app/actions/app_actions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'common.dart';

import '../models/app_state.dart';
import '../models/user.dart';

enum UserStatus {
  loggedIn,
  loggoutOut,
  banned,
  error
}

class UserManager {
  Store<AppState> store;
  User currentUser;
  String baseURL = "vorulistar.gudmunduro.com";

  UserManager({this.store, this.currentUser});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _userDataFile async {
    final path = await _localPath;
    return File('$path/userData.json');
  }

  String get bearerAuthHeader {
    return 'Bearer ${currentUser?.token ?? ''}';
  }

  void writeToFile(String content) async {
    final file = await _userDataFile;
    file.writeAsString(content);
  }

  Future<String> readFromFile() async {
    final file = await _userDataFile;
    if (!(await file.exists()))
      throw FileDoesNotExistException("File does not exists");
    return await file.readAsString();
  }

  void saveCurrentUser() {
    writeToFile(jsonEncode(currentUser.toJsonObject()));
  }

  Future<bool> login(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(
        Uri.https(baseURL, "/api/user/login"),
        headers: {'authorization': basicAuth});
    if (response.statusCode == 200) {
      final Map jsonResponse = jsonDecode(response.body);

      currentUser = User(
          name: jsonResponse["name"],
          username: username,
          ssn: null,
          token: jsonResponse["token"]);

      saveCurrentUser();
      store.dispatch(UpdateUserAction(user: currentUser));
      return true;
    } else {
      return false;
    }
  }

  Future create(String name, String username, String password,
      String verifyPassword) async {
    final response =
        await http.post(Uri.https(baseURL, "/api/user/create"), body: {
      'name': name,
      'username': username,
      'password': password,
      'verifyPassword': verifyPassword
    });
    if (response.statusCode == 200) {
      await login(username, password);
    }
  }

  Future logout() async {
    final response = await http.get(
      Uri.https(baseURL, "/api/user/logout"),
      headers: {'Authorization': bearerAuthHeader},
    );
    if (response.statusCode == 200 || response.statusCode == 401) {
      store.dispatch(UpdateUserAction(user: null));
      writeToFile("");
    }
  }

  Future<UserStatus> verifyUser() async {
    final response = await http.get(
      Uri.https(baseURL, "/api/user/info"),
      headers: {'Authorization': bearerAuthHeader},
    );
    if (response.statusCode == 200) {
      return UserStatus.loggedIn;
    } else if (response.statusCode == 401) {
      store.dispatch(UpdateUserAction(user: null));
      writeToFile("");
      return UserStatus.loggoutOut;
    } else if (response.statusCode == 403) {
      store.dispatch(UpdateUserAction(user: null));
      writeToFile("");
      return UserStatus.banned;
    }
    return UserStatus.error;
  }

  Future loadUserFromFile() async {
    try {
      final userJsonData = await readFromFile();
      print(userJsonData);
      if (userJsonData == "") return;
      Map userJsonObject = json.decode(userJsonData);
      currentUser = User.fromJsonObject(userJsonObject);

      store.dispatch(UpdateUserAction(user: currentUser));
    } catch (error) {
      print(error);
    }
  }

  Future<bool> uploadProductLists() async {
    final directory = await getApplicationDocumentsDirectory();
    final formData = FormData.from({
      "file": new UploadFileInfo(
          File('${directory.path}/productLists.json'), "productLists.json")
    });

    final response =
        await Dio().post("https://$baseURL/api/productLists/upload",
            data: formData,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: bearerAuthHeader,
            }));
    if (response.statusCode == 200 && response.data != null && response.data['success'] == 1) {
      return true;
    }
    if (response.statusCode == 401) {
      await logout();
    }
    return false;
  }
}
