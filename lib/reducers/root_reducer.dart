import 'package:husa_app/reducers/app_ready_reducer.dart';
import 'product_reducers.dart';
import '../models/app_state.dart';

AppState rootReducer(AppState state, action) {
  return new AppState(
      appReady: appReadyReducer(state.appReady, action),
      productLoaded: productLoadedReducer(state.productLoaded, action),
      productSearchResult: productSearchResultReducer(state.productSearchResult, state.productList, action),
      productLists: productListsReducer(state.productLists, action),
      productList: productListReducer(state.productList, action),
  );
}

