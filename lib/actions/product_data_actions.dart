import 'package:flutter/foundation.dart';
import '../models/product_data.dart';

enum ProductDataSearchType {
  productNumber,
  name,
  description,
}

class SearchProductDataAction {
  final List<ProductDataSearchType> searchTypes;
  final String searchString;

  SearchProductDataAction({
    @required this.searchTypes,
    @required this.searchString,
  });
}

class UpdateProductDataSearchResultsAction {
  final List<int> productIndexes;
  final String searchString;
  final List<ProductDataSearchType> searchTypes;

  UpdateProductDataSearchResultsAction(
      {@required this.productIndexes,
      @required this.searchString,
      @required this.searchTypes});
}

class UpdateProductDataAction {
  final List<Product> productList;

  UpdateProductDataAction(
    this.productList,
  );
}