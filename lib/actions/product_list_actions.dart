import 'package:flutter/foundation.dart';
import '../models/product_list.dart';

// List

// Add
class AddProductListAction {
  final String name;

  AddProductListAction({
    @required this.name,
  });
}

// Update
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

// Delete
class DeleteProductListAction {
  final int index;

  DeleteProductListAction({this.index});
}

class ReplaceProductListsAction {
  final List<ProductList> productLists;

  ReplaceProductListsAction({
    this.productLists,
  });
}


// List items

// Add
class AddToProductListAction {
  ProductListItem productListItem;
  final int index;

  AddToProductListAction({
    @required this.productListItem,
    @required this.index,
  });
}

// Update
class UpdateProductListItemAction {
  final int listIndex;
  final int itemIndex;
  final ProductListItem newProductListItem;

  UpdateProductListItemAction(
      {this.listIndex, this.itemIndex, this.newProductListItem});
}

class CopyProductListItemAction {
  final int originalListIndex;
  final int targetListIndex;
  final int itemIndex;

  CopyProductListItemAction(
      {this.originalListIndex, this.targetListIndex, this.itemIndex});
}

class MoveProductListItemAction {
  final int originalListIndex;
  final int targetListIndex;
  final int itemIndex;

  MoveProductListItemAction(
      {this.originalListIndex, this.targetListIndex, this.itemIndex});
}

// Delete
class DeleteProductListItemAction {
  final int listIndex;
  final int itemIndex;

  DeleteProductListItemAction({this.listIndex, this.itemIndex});
}

class DeleteAllProductListItemsAction {
  final int listIndex;

  DeleteAllProductListItemsAction({this.listIndex});
}
