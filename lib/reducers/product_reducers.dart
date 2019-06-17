import '../actions/product_actions.dart';
import '../models/app_state.dart';
import '../models/product.dart';

ProductSearchResult productSearchResultReducer(
    ProductSearchResult productSearchResult,
    List<Product> productList,
    action) {
  if (action is SearchProductAction) {
    return productSearchResult;
  } else if (action is UpdateProductSearchResultsAction) {
    return ProductSearchResult(
      productIndexes: action.productIndexes,
      searchString: action.searchString,
      searchTypes: action.searchTypes,
    );
  } else {
    return productSearchResult;
  }
}

List<ProductList> productListsReducer(List<ProductList> productLists, action) {
  if (action is AddToProductListAction) {
    productLists[action.index] =
        productListsListReducer(productLists[action.index], action);

  } else if (action is UpdateProductListItemAction) {
    productLists[action.listIndex] =
        productListsListReducer(productLists[action.listIndex], action);

  } else if (action is UpdateProductListAction) {
    productLists[action.index] =
        productListsListReducer(productLists[action.index], action);

  } else if (action is DeleteProductListItemAction) {
    productLists[action.listIndex] =
        productListsListReducer(productLists[action.listIndex], action);

  } else if (action is DeleteAllProductListItemsAction) {
    productLists[action.listIndex] =
        productListsListReducer(productLists[action.listIndex], action);

  } else if (action is AddProductListAction) {
    productLists.add(ProductList(name: action.name, list: List()));

  } else if (action is DeleteProductListAction) {
    productLists.removeAt(action.index);
  
  } else if (action is ReplaceProductListsAction) {
    return action.productLists;

  }
  return productLists;
}

ProductList productListsListReducer(ProductList prodcutList, action) {
  if (action is AddToProductListAction) {
    prodcutList.list.add(ProductListItem(
        productNumber: action.productNumber, count: action.count));
  } else if (action is UpdateProductListItemAction) {
    prodcutList.list[action.itemIndex] = ProductListItem(
        productNumber: action.productNumber,
        count: action.count,
        note: action.note);
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

bool productLoadedReducer(bool loaded, action) {
  if (action is SearchProductAction) {
    return true;
  } else {
    return loaded;
  }
}

List<Product> productListReducer(List<Product> productList, action) {
  if (action is UpdateProductDataAction) {
    return action.productList;
  }
  return productList;
}
