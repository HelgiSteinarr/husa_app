import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:husa_app/utilities/search.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'screens/main_screen.dart';
import 'actions/product_actions.dart';
import 'models/app_state.dart';
import 'models/product.dart';
import 'reducers/root_reducer.dart';
import 'utilities/save_manager.dart';

void main() => runApp(AppRoot());

class AppRoot extends StatefulWidget {
  AppRoot({Key key}) : super(key: key);

  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  final store = new Store<AppState>(
    rootReducer,
    initialState: new AppState(
        appReady: false,
        productLoaded: false,
        productSearchResult: ProductSearchResult(
            productIndexes: List(),
            searchString: "",
            searchTypes: [ProductSearchType.productNumber, ProductSearchType.name]),
        productLists: List(),
        productList: List()),
    middleware: []..add(createSaveMiddleware())..add(createSearchMiddleware()),
  );

  void loadProducts() async {
    final jsonString =
        await DefaultAssetBundle.of(context).loadString("assets/products.json");
    final List productsJson = json.decode(jsonString);
    final List<Product> productList = productsJson
        .map((productData) => Product.fromJson(productData))
        .toList();
    final updateProductListAction = UpdateProductDataAction(productList);
    store.dispatch(updateProductListAction);
  }

  void loadProductLists() async {
    try {
      var saveManager = ProductListsSaveManager(store.state);
      var productLists = await saveManager.load();
      store.dispatch(ReplaceProductListsAction(productLists: productLists));
    } catch (e) {
      print("Failed to load product lists data $e");
    }
  }

  @override
  void initState() {
    super.initState();
    if (!store.state.appReady) {
      loadProducts();
      loadProductLists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: store,
        child: new MaterialApp(
          title: 'Húsasmiðjan',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: MainScreen(),
        ));
  }
}
