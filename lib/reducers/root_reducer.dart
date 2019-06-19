import 'package:husa_app/reducers/app_reducers.dart';
import 'product_data_reducers.dart';
import 'product_list_reducers.dart';
import '../models/app_state.dart';

AppState rootReducer(AppState state, action) {
  return new AppState(
      appReady: appReadyReducer(state.appReady, action),
      productLoaded: productLoadedReducer(state.productLoaded, action),
      productSearchResult: productDataSearchResultReducer(state.productSearchResult, state.productData, action),
      productLists: productListsReducer(state.productLists, action),
      productData: productDataReducer(state.productData, action),
  );
}

