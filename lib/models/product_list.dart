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
