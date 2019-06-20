import 'package:flutter/material.dart';

class ColorLabel {
  static List<Color> labelColors = [
    Colors.black45,
    Colors.red,
    Colors.orange,
    Colors.deepOrange,
    Colors.yellow,
    Colors.cyan,
    Colors.green,
    Colors.blue
  ];

  final int colorIndex;
  final String text;

  ColorLabel({this.colorIndex, this.text});
  
  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["colorIndex"] = colorIndex;
    jsonMap["text"] = text;
    return jsonMap;
  }

  static ColorLabel fromJsonObject(Map<String, dynamic> jsonObject) {
    return ColorLabel(
      colorIndex: jsonObject["colorIndex"],
      text: jsonObject["text"],
    );
  }
}

class ProductList {
  String name;
  List<ProductListItem> list;
  String note;
  List<ColorLabel> labels;

  ProductList({this.name, this.list, this.note, this.labels});

  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["name"] = name;
    jsonMap["list"] = list.map((i) => i.toJsonObject()).toList();
    jsonMap["note"] = note;
    jsonMap["labels"] = labels.map((i) => i.toJsonObject()).toList();
    return jsonMap;
  }

  static ProductList fromJsonObject(Map<String, dynamic> jsonObject) {
    List list = jsonObject["list"] ?? [];
    List labels = jsonObject["labels"] ?? [];
    return ProductList(
      name: jsonObject["name"],
      list: list.map((i) => ProductListItem.fromJsonObject(i)).toList(),
      note: jsonObject["note"],
      labels: labels.map((i) => ColorLabel.fromJsonObject(i)).toList(),
    );
  }
}

class ProductListItem {
  String productNumber;
  int count;
  String note;
  int labelIndex;

  ProductListItem({this.productNumber, this.count, this.note, this.labelIndex});

  Map<String, dynamic> toJsonObject() {
    var jsonMap = Map<String, dynamic>();
    jsonMap["productNumber"] = productNumber;
    jsonMap["count"] = count;
    jsonMap["note"] = note;
    jsonMap["labelIndex"] = labelIndex;
    return jsonMap;
  }

  static ProductListItem fromJsonObject(Map<String, dynamic> jsonObject) {
    return ProductListItem(
      productNumber: jsonObject["productNumber"],
      count: jsonObject["count"],
      note: jsonObject["note"],
      labelIndex: jsonObject["labelIndex"],
    );
  }
}
