import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:husa_app/utilities/product_data_manager.dart';
import 'package:husa_app/widgets/UpdateDataDialog.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'utilities/search.dart';
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

  @override
  void initState() {
    super.initState();
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
