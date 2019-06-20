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

class AddProductListLabelAction {
  final ColorLabel label;
  final int listIndex;

  AddProductListLabelAction({
    @required this.label,
    @required this.listIndex,
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

  DeleteProductListAction({
    @required this.index,
  });
}

class DeleteProductListLabelAction {
  final int labelIndex;
  final int listIndex;

  DeleteProductListLabelAction({
    @required this.labelIndex,
    @required this.listIndex,
  });
}

class ReplaceProductListsAction {
  final List<ProductList> productLists;

  ReplaceProductListsAction({
    @required this.productLists,
  });
}

// List items

// Add
class AddToProductListAction {
  final ProductListItem productListItem;
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

  UpdateProductListItemAction({
    @required this.listIndex,
    @required this.itemIndex,
    @required this.newProductListItem,
  });
}

class CopyProductListItemAction {
  final int originalListIndex;
  final int targetListIndex;
  final int itemIndex;

  CopyProductListItemAction({
    @required this.originalListIndex,
    @required this.targetListIndex,
    @required this.itemIndex,
  });
}

class MoveProductListItemAction {
  final int originalListIndex;
  final int targetListIndex;
  final int itemIndex;

  MoveProductListItemAction({
    @required this.originalListIndex,
    @required this.targetListIndex,
    @required this.itemIndex,
  });
}

// Delete
class DeleteProductListItemAction {
  final int listIndex;
  final int itemIndex;

  DeleteProductListItemAction({
    @required this.listIndex,
    @required this.itemIndex,
  });
}

class DeleteAllProductListItemsAction {
  final int listIndex;

  DeleteAllProductListItemsAction({
    @required this.listIndex,
  });
}
