import 'package:flutter/foundation.dart';
import 'product.dart';

class AppState {
  final bool appReady;
  final bool productLoaded;
  final ProductSearchResult productSearchResult;
  final List<Product> productList;
  final List<ProductList> productLists;

  AppState({
    @required this.appReady,
    @required this.productLoaded,
    @required this.productSearchResult,
    @required this.productList,
    @required this.productLists,
  });

  AppState copyWith({bool appReady, bool productLoaded, int selectedProductIndex, List<Product> productList, List<ProductList> productLists}) {
    return new AppState(
      appReady: appReady ?? this.appReady,
      productLoaded: productLoaded ?? this.productLoaded,
      productSearchResult: selectedProductIndex ?? this.productSearchResult,
      productList: productList ?? this.productList,
      productLists: productLists ?? this.productLists,
    );
  }

}