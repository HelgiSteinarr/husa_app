import 'package:flutter/foundation.dart';
import '../actions/product_data_actions.dart';

class Product {
  final String name;
  final String productNumber;
  final int price;
  final String description;
  final String url;
  final String imageUrl;

  Product({
    @required this.name,
    @required this.productNumber,
    @required this.price,
    @required this.description,
    @required this.url,
    @required this.imageUrl,
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
      url: json["Url"],
      imageUrl: json["ImageUrl"] ?? "",
    );
  }
}

class ProductDataSearchResult {
  final String searchString;
  final List<int> productIndexes;
  final List<ProductDataSearchType> searchTypes;
  final int selectedIndex;

  ProductDataSearchResult({
    @required this.searchString,
    @required this.productIndexes,
    @required this.searchTypes,
    this.selectedIndex,
  });
}