import 'package:flutter/foundation.dart';
import 'package:husa_app/models/mtp_data.dart';
import 'product_data.dart';
import 'product_list.dart';
import 'user.dart';

class AppState {
  final bool appReady;
  final bool productLoaded;
  final ProductDataSearchResult productSearchResult;
  final List<Product> productData;
  final List<ProductList> productLists;
  final User currentUser;
  final MtpData mtpData;

  AppState({
    @required this.appReady,
    @required this.productLoaded,
    @required this.productSearchResult,
    @required this.productData,
    @required this.productLists,
    @required this.currentUser,
    @required this.mtpData,
  });

  AppState copyWith({bool appReady, bool productLoaded, ProductDataSearchResult productSearchResult, List<Product> productData, List<ProductList> productLists, User currentUser}) {
    return new AppState(
      appReady: appReady ?? this.appReady,
      productLoaded: productLoaded ?? this.productLoaded,
      productSearchResult: productSearchResult ?? this.productSearchResult,
      productData: productData ?? this.productData,
      productLists: productLists ?? this.productLists,
      currentUser: currentUser ?? this.currentUser,
      mtpData: mtpData ?? this.mtpData,
    );
  }

}