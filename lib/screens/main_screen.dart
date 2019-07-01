import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/product_data_actions.dart';
import 'package:husa_app/actions/product_list_actions.dart';
import 'package:husa_app/models/app_state.dart';
import 'package:husa_app/models/product_data.dart';
import 'package:husa_app/screens/product_lists/product_lists_page.dart';
import 'package:husa_app/screens/product_search/product_search_page.dart';
import 'package:husa_app/screens/settings/settings_page.dart';
import 'package:husa_app/utilities/common.dart';
import 'package:husa_app/utilities/product_data_manager.dart';
import 'package:husa_app/utilities/save_manager.dart';
import 'package:husa_app/widgets/UpdateDataDialog.dart';
import 'package:redux/redux.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    ProductSearchPage(),
    ProductListsPage(),
    SettingsPage(),
  ];

  bool firstTime = true;
  int currentIndex = 0;

  Future showUpdateProductDataView(BuildContext context, _ViewModel vm) async {
    var oldContext = context;

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UpdateProductDataDialog(
            store: vm.store,
            onFinished: (success) {
              var message = (success)
                  ? "Tókst að uppfæra gögn frá síðu"
                  : "Tókst ekki að uppfæra gögn frá síðu";
              Scaffold.of(oldContext)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
          );
        });
  }

  Future loadProductData(BuildContext context, _ViewModel vm) async {
    var productDataManager = ProductDataManager(store: vm.store);
    if (!(await productDataManager.loadFile())) {
      await showUpdateProductDataView(context, vm);
    }
    vm.store.dispatch(SearchProductDataAction(
      searchString: "",
      searchTypes: vm.productSearchResult.searchTypes,
    ));
  }

  void loadProductLists(_ViewModel vm) async {
    try {
      var saveManager = ProductListsSaveManager(vm.store.state);
      var productLists = await saveManager.load();
      vm.store.dispatch(ReplaceProductListsAction(productLists: productLists));
    } catch (e) {
      print("Failed to load product lists data $e");
    }
  }

  void onTabTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            body: Builder(
              builder: (context) {
                if (firstTime && !vm.appReady) {
                  loadProductData(context, vm);
                  loadProductLists(vm);
                  firstTime = false;
                }

                return pages[currentIndex];
              },
            ),
            bottomNavigationBar: BottomNavigationBar(items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), title: Text("Vöruflettir")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.assignment), title: Text("Vörulistar")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text("Stillingar")),
            ], currentIndex: currentIndex, onTap: onTabTap),
          );
        });
  }
}

class _ViewModel {
  final Store<AppState> store;
  final bool appReady;
  final ProductDataSearchResult productSearchResult;

  _ViewModel({
    @required this.store,
    @required this.appReady,
    @required this.productSearchResult,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      store: store,
      appReady: store.state.appReady,
      productSearchResult: store.state.productSearchResult,
    );
  }
}
