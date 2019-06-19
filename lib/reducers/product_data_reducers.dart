import '../actions/product_data_actions.dart';
import '../models/app_state.dart';
import '../models/product_data.dart';

ProductDataSearchResult productDataSearchResultReducer(
    ProductDataSearchResult productSearchResult,
    List<Product> productList,
    action) {
  if (action is SearchProductDataAction) {
    return productSearchResult;

  } else if (action is UpdateProductDataSearchResultsAction) {
    return ProductDataSearchResult(
      productIndexes: action.productIndexes,
      searchString: action.searchString,
      searchTypes: action.searchTypes,
    );

  } else {
    return productSearchResult;
  }
}

bool productLoadedReducer(bool loaded, action) {
  if (action is SearchProductDataAction) {
    return true;
  } else {
    return loaded;
  }
}

List<Product> productDataReducer(List<Product> productList, action) {
  if (action is UpdateProductDataAction) {
    return action.productList;
  }
  return productList;
}
