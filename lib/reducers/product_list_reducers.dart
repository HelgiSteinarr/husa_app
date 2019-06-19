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

ProductList productListReducer(ProductList prodcutList, action) {
  if (action is AddToProductListAction) {
    prodcutList.list.add(action.productListItem);
  } else if (action is UpdateProductListItemAction) {
    prodcutList.list[action.itemIndex] = action.newProductListItem;
  } else if (action is UpdateProductListAction) {
    prodcutList.name = action.name;
    prodcutList.note = action.note;
  } else if (action is DeleteProductListItemAction) {
    prodcutList.list.removeAt(action.itemIndex);
  } else if (action is DeleteAllProductListItemsAction) {
    prodcutList.list.clear();
  }
  return prodcutList;
}
