import 'dart:io';
import 'dart:convert';
import 'package:husa_app/actions/app_actions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../models/app_state.dart';
import '../models/user.dart';

class UserManager {
  Store<AppState> store;
  User currentUser;

  UserManager({this.store, this.currentUser});

  String get bearerAuthHeader {
    return 'Bearer ${currentUser?.token ?? ''}';
  }

  Future login(String username, String password) async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$username:$password'));
    final response = await http.post(
        Uri.http("10.0.2.2:8080", "/api/user/login"),
        headers: {'authorization': basicAuth});
    if (response.statusCode == 200) {
      final Map jsonResponse = jsonDecode(response.body);

      currentUser =
          User(name: "", username: username, token: jsonResponse["token"]);

      store.dispatch(UpdateUserAction(user: currentUser));
    } else {
      return null;
    }
  }

  Future logout() async {
    print(bearerAuthHeader);
    final response = await http.get(
      Uri.http("10.0.2.2:8080", "/api/user/logout"),
      headers: {'Authorization': bearerAuthHeader},
    );
    if (response.statusCode == 200) {
      store.dispatch(UpdateUserAction(user: null));
    }
  }

  Future uploadProductLists() async {
    final directory = await getApplicationDocumentsDirectory();
    final formData = FormData.from({
      "file": new UploadFileInfo(
          File('${directory.path}/productLists.json'), "productLists.json")
    });

    final response =
        await Dio().post("10.0.2.2:8080/api/productLists/upload",
            data: formData,
            options: Options(headers: {
              HttpHeaders.authorizationHeader: bearerAuthHeader,
            }));
  
    final Map jsonResponse = jsonDecode(response.data);
    if (jsonResponse != null &&
        jsonResponse.containsKey("error") &&
        jsonResponse["error"] == 0) {
    } else {}
  }
}
