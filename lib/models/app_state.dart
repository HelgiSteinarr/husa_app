import 'package:flutter/foundation.dart';
import 'product_data.dart';
import 'product_list.dart';

class AppState {
  final bool appReady;
  final bool productLoaded;
  final ProductDataSearchResult productSearchResult;
  final List<Product> productData;
  final List<ProductList> productLists;

  AppState({
    @required this.appReady,
    @required this.productLoaded,
    @required this.productSearchResult,
    @required this.productData,
    @required this.productLists,
  });

  AppState copyWith({bool appReady, bool productLoaded, ProductDataSearchResult productSearchResult, List<Product> productData, List<ProductList> productLists}) {
    return new AppState(
      appReady: appReady ?? this.appReady,
      productLoaded: productLoaded ?? this.productLoaded,
      productSearchResult: productSearchResult ?? this.productSearchResult,
      productData: productData ?? this.productData,
      productLists: productLists ?? this.productLists,
    );
  }

}