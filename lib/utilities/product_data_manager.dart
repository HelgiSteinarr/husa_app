import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:redux/redux.dart';

import '../actions/product_data_actions.dart';
import '../utilities/common.dart';
import '../models/app_state.dart';
import '../models/product_data.dart';

class ProductDataManager {
  ProductDataManager({this.store});

  List<String> catUrls = List();
  List<String> catIds = List();
  List<String> subCatIds = List();
  List productData = List();
  Store<AppState> store;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _file async {
    final path = await _localPath;
    return File('$path/productData.json');
  }

  Future _extractCatUrls() async {
    final response = await http.get("https://husa.is");
    final pageSource = response.body;
    final document = parse(pageSource);

    catUrls = document.getElementsByClassName("subcategory").map(
        (subCat) => subCat.getElementsByTagName("a")[0].attributes["href"]).toList();
  }

  Future _extractCatIds() async {
    for (var url in catUrls) {
      print("Extracting cat id from $url");
      final response = await http.get("https://husa.is$url");
      final pageSource = response.body;
      final document = parse(pageSource);

      final loadingRows = document.getElementsByClassName("row loading");
      if (loadingRows.length == 0) continue;
      final catId = loadingRows[0].attributes["data-parentcategory"];
      if (catId == null) continue;

      catIds.add(catId);
    }
  }

  Future _extractSubCatIds() async {
    for (var catId in catIds) {
      print("Extracting subcat ids for $catId");
      final response = await http.get("https://www.husa.is/umbraco/api/product/GetSubCategories?categoryId=$catId");
      final List jsonObject = json.decode(response.body);
      subCatIds.addAll(jsonObject.map((o) => o["Id"].toString()).toList());
    }
  }

  Future _extractProductInfo() async {
    for (var subCatId in subCatIds) {
        print("Extracting product info for $subCatId");
        final response = await http.get("https://www.husa.is/umbraco/api/product/GetProducts?categoryId=$subCatId");
        final List jsonObject = json.decode(response.body);

        productData.addAll(jsonObject);
    }
  }

  Future _save() async {
    var file = await _file;
    var jsonContent = json.encode(productData);
    file.writeAsString(jsonContent);
  }

  void _updateStore() {
    final List<Product> productList = productData
        .map((productData) => Product.fromJson(productData))
        .toList();

    store.dispatch(UpdateProductDataAction(productList));
  }

  Future<String> _readFromFile() async {
    final file = await _file;
    if (!(await file.exists())) throw FileDoesNotExistException("File does not exists");
    return await file.readAsString();
  }

  // Public functions

  Future<bool> update() async {
    print("Updating");
    try {
      await _extractCatUrls();
      await _extractCatIds();
      await _extractSubCatIds();
      await _extractProductInfo();
      await _save();
      _updateStore();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> loadFile() async {
    try {
      var fileData = await _readFromFile();
      productData = json.decode(fileData);
      _updateStore();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
