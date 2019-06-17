import 'package:flutter/foundation.dart';
import '../models/product.dart';

enum ProductSearchType {
  productNumber,
  name,
  description,
}

class SearchProductAction {
  final List<ProductSearchType> searchTypes;
  final String searchString;

  SearchProductAction({
    @required this.searchTypes,
    @required this.searchString,
  });
}

class UpdateProductSearchResultsAction {
  final List<int> productIndexes;
  final String searchString;
  final List<ProductSearchType> searchTypes;

  UpdateProductSearchResultsAction({
    @required this.productIndexes,
    @required this.searchString,
    @required this.searchTypes
  });
}

class UpdateProductDataAction {
  final List<Product> productList;

  UpdateProductDataAction(
    this.productList,
  );
}

class AddToProductListAction {
  final String productNumber;
  final int count;
  final int index;

  AddToProductListAction({
    @required this.productNumber,
    @required this.count,
    @required this.index,
  });
}

class AddProductListAction {
  final String name;

  AddProductListAction({
    @required this.name,
  });
}

class UpdateProductListAction {
  final int index;
  final String name;
  final String note;

  UpdateProductListAction({
    @required this.index,
    @required this.name,
    @required this.note,
  });
}

class DeleteProductListAction {
  final int index;

  DeleteProductListAction({this.index});
}

class UpdateProductListItemAction {
  final int listIndex;
  final int itemIndex;
  final String productNumber;
  final int count;
  final String note;

  UpdateProductListItemAction({this.listIndex, this.itemIndex, this.productNumber, this.count, this.note});
}

class DeleteProductListItemAction {
  final int listIndex;
  final int itemIndex;

  DeleteProductListItemAction({this.listIndex, this.itemIndex});
}

class DeleteAllProductListItemsAction {
  final int listIndex;

  DeleteAllProductListItemsAction({this.listIndex});
}

class ReplaceProductListsAction {
  final List<ProductList> productLists;

  ReplaceProductListsAction({
    this.productLists,
  });
}