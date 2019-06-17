import 'package:flutter/foundation.dart';
import 'package:husa_app/actions/product_actions.dart';

class Product {
  final String name;
  final String productNumber;
  final int price;
  final String description;
  final String url;

  Product({
    @required this.name,
    @required this.productNumber,
    @required this.price,
    @required this.description,
    @required this.url,
  });

  static Product fromJson(Map<String, dynamic> json) {
    int priceValue;
    if (json["CurrencyString"] is double) {
      priceValue = json["CurrencyString"].round();
    } else {
      priceValue = json["CurrencyString"];
    }
    return Product(
      name: json["Title"],
      productNumber: json["Id"],
      price: priceValue,
      description: json["Description"] ?? "",
      url: json["Url"]
    );
  }
}

class ProductList {
  String name;
  List<ProductListItem> list;
  String note;

  ProductList({this.name, this.list, this.note});

  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["name"] = name;
    jsonMap["list"] = list.map((i) => i.toJsonObject()).toList();
    jsonMap["note"] = note;
    return jsonMap;
  }

  static ProductList fromJsonObject(Map<String, dynamic> jsonObject) {
    List list = jsonObject["list"];
    return ProductList(
      name: jsonObject["name"],
      list: list.map((i) => ProductListItem.fromJsonObject(i)).toList(),
      note: jsonObject["note"],
    );
  }
}

class ProductListItem {
  String productNumber;
  int count;
  String note;

  ProductListItem({this.productNumber, this.count, this.note});

  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["productNumber"] = productNumber;
    jsonMap["count"] = count;
    jsonMap["note"] = note;
    return jsonMap;
  }

  static ProductListItem fromJsonObject(Map<String, dynamic> jsonObject) {
    return ProductListItem(
      productNumber: jsonObject["productNumber"],
      count: jsonObject["count"],
      note: jsonObject["note"],
    );
  }
}

class ProductSearchResult {
  final String searchString;
  final List<int> productIndexes;
  final List<ProductSearchType> searchTypes;
  final int selectedIndex;

  ProductSearchResult({
    @required this.searchString,
    @required this.productIndexes,
    @required this.searchTypes,
    this.selectedIndex,
  });
}