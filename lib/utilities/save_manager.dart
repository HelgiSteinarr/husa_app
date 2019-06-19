import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:husa_app/utilities/common.dart';
import 'package:redux/redux.dart';
import '../actions/app_actions.dart';
import '../models/product_list.dart';
import '../models/app_state.dart';

Middleware<AppState> createSaveMiddleware() {
  return (Store store, action, NextDispatcher next) async {
    if (action is SaveProductListsAction) {
      var saveManager = ProductListsSaveManager(store.state);
      try {
        saveManager.save();
      } catch (e) {
        print("Failed to save data $e");
      }
    }
    next(action);
  };
}

class ProductListsSaveManager {

  AppState state;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/productLists.json');
  }

  ProductListsSaveManager(
    this.state,
  );

  void writeToFile(String content) async {
    final file = await _localFile;
    file.writeAsString(content);
  }

  Future<String> readFromFile() async {
    final file = await _localFile;
    if (!(await file.exists())) throw FileDoesNotExistException("File does not exists");
    return await file.readAsString();
  }

  void save() async {
    var jsonObject = state.productLists.map((i) => i.toJsonObject()).toList();
    writeToFile(json.encode(jsonObject));
  }

  Future<List<ProductList>> load() async {
    String content = await readFromFile();
    List jsonObject = json.decode(content);
    return jsonObject.map((i) => ProductList.fromJsonObject(i)).toList();
  }


}