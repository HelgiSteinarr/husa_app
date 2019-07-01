import 'package:flutter/material.dart';
import 'package:husa_app/actions/product_data_actions.dart';
import 'package:husa_app/models/product_data.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'utilities/search.dart';
import 'screens/main_screen.dart';
import 'models/app_state.dart';
import 'reducers/root_reducer.dart';
import 'utilities/save_manager.dart';

void main() => runApp(AppRoot());

class AppRoot extends StatefulWidget {
  AppRoot({Key key}) : super(key: key);

  @override
  AppRootState createState() => AppRootState();
}

class AppRootState extends State<AppRoot> {
  final store = new Store<AppState>(
    rootReducer,
    initialState: new AppState(
        appReady: false,
        productLoaded: false,
        productSearchResult: ProductDataSearchResult(
            productIndexes: List(),
            searchString: "",
            searchTypes: [ProductDataSearchType.productNumber, ProductDataSearchType.name]),
        productLists: List(),
        productData: List()),
    middleware: []..add(createSaveMiddleware())..add(createSearchMiddleware()),
  );

  @override
  void initState() {
    super.initState();
  }

  void restartApp() {
    this.setState(() {});
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
