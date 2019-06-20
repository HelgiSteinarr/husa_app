import '../actions/product_list_actions.dart';
import '../models/app_state.dart';
import '../models/product_list.dart';

List<ProductList> productListsReducer(List<ProductList> productLists, action) {
  if (action is AddToProductListAction) {
    productLists[action.index] =
        productListReducer(productLists[action.index], action);

  } else if (action is UpdateProductListItemAction) {
    productLists[action.listIndex] =
        productListReducer(productLists[action.listIndex], action);

  } else if (action is UpdateProductListAction) {
    productLists[action.index] =
        productListReducer(productLists[action.index], action);
  } else if (action is AddProductListLabelAction) {
    var labels = productLists[action.listIndex].labels;
    labels = productListLabelsReducer(labels, action);

  } else if (action is DeleteProductListLabelAction) {
    var labels = productLists[action.listIndex].labels;
    labels = productListLabelsReducer(labels, action);
    productLists[action.listIndex] = 
        productListReducer(productLists[action.listIndex], action);

  } else if (action is DeleteProductListItemAction) {
    productLists[action.listIndex] =
        productListReducer(productLists[action.listIndex], action);

  } else if (action is DeleteAllProductListItemsAction) {
    productLists[action.listIndex] =
        productListReducer(productLists[action.listIndex], action);

  } else if (action is AddProductListAction) {
    productLists.add(ProductList(name: action.name, list: List()));

  } else if (action is CopyProductListItemAction) {
    var productListItem = productLists[action.originalListIndex].list[action.itemIndex];
    productLists[action.targetListIndex].list.add(productListItem);

  } else if (action is MoveProductListItemAction) {
    var productListItem = productLists[action.originalListIndex].list[action.itemIndex];
    productLists[action.targetListIndex].list.add(productListItem);
    productLists[action.originalListIndex].list.removeAt(action.itemIndex);

  } else if (action is DeleteProductListAction) {
    productLists.removeAt(action.index);
  
  } else if (action is ReplaceProductListsAction) {
    return action.productLists;

  }
  return productLists;
}

List<ColorLabel> productListLabelsReducer(List<ColorLabel> labels, action) {
  if (action is AddProductListLabelAction) {
    labels.add(action.label);
  } else if (action is DeleteProductListLabelAction) {
    labels.removeAt(action.labelIndex);
  }
  return labels;
}

ProductList productListReducer(ProductList productList, action) {
  if (action is AddToProductListAction) {
    productList.list.add(action.productListItem);
  } else if (action is UpdateProductListItemAction) {
    productList.list[action.itemIndex] = action.newProductListItem;
  } else if (action is UpdateProductListAction) {
    productList.name = action.name;
    productList.note = action.note;
  } else if (action is DeleteProductListLabelAction) {
    productList.list = productList.list.map((item) {
      if (item.labelIndex == action.labelIndex) {
        item.labelIndex = null;
      }
      return item;
    }).toList();
  } else if (action is DeleteProductListItemAction) {
    productList.list.removeAt(action.itemIndex);
  } else if (action is DeleteAllProductListItemsAction) {
    productList.list.clear();
  }
  return productList;
}
