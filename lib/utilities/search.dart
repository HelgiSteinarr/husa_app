import 'package:husa_app/actions/product_data_actions.dart';
import 'package:redux/redux.dart';
import '../actions/app_actions.dart';
import '../models/product_data.dart';
import '../models/app_state.dart';
import 'package:async/async.dart';

CancelableOperation searchOperation;

Middleware<AppState> createSearchMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is SearchProductDataAction) {
      if (searchOperation != null) {
        searchOperation.cancel();
      }
      searchOperation = CancelableOperation.fromFuture(() async {

        if (action.searchString == "") {
          var productIndexes = List<int>.generate(store.state.productData.length, (index) => index);

          return UpdateProductDataSearchResultsAction(
            productIndexes: productIndexes,
            searchString: action.searchString,
            searchTypes: action.searchTypes,
          );
        }

        bool searchInProductNumbers =
            action.searchTypes.contains(ProductDataSearchType.productNumber);
        bool searchInNames =
            action.searchTypes.contains(ProductDataSearchType.name);
        bool searchInDescriptions =
            action.searchTypes.contains(ProductDataSearchType.description);

        List<Product> productList = store.state.productData;
        List<int> foundProductsIndexes = List();
        String searchString = action.searchString.toLowerCase();

        for (int i = 0; i < productList.length; i++) {
          var product = productList[i];
          if (searchInProductNumbers &&
              product.productNumber
                  .toLowerCase()
                  .contains(searchString)) {
            foundProductsIndexes.add(i);
          } else if (searchInNames &&
              product.name
                  .toLowerCase()
                  .contains(searchString)) {
            foundProductsIndexes.add(i);
          } else if (searchInDescriptions &&
              product.description
                  .toLowerCase()
                  .contains(searchString)) {
            foundProductsIndexes.add(i);
          }
        }

        return UpdateProductDataSearchResultsAction(
          productIndexes: foundProductsIndexes,
          searchString: action.searchString,
          searchTypes: action.searchTypes,
        );
      }());

      searchOperation.value.then((updateProductSearchResultsAction) {
        store.dispatch(updateProductSearchResultsAction);
      });
    }
    next(action);
  };
}
