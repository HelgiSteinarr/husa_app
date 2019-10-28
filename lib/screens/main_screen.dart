import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'product_lists/product_lists_page.dart';
import 'product_search/product_search_page.dart';
import 'clock/clock_page.dart';
import 'settings/settings_page.dart';
import 'user/user_login_screen.dart';
import '../utilities/user_manager.dart';
import '../actions/product_data_actions.dart';
import '../actions/product_list_actions.dart';
import '../models/app_state.dart';
import '../models/product_data.dart';
import '../utilities/product_data_manager.dart';
import '../utilities/save_manager.dart';
import '../widgets/UpdateDataDialog.dart';
import '../widgets/SimpleAlertDialog.dart';
import '../models/user.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> pages = [
    ProductSearchPage(),
    ProductListsPage(),
    ClockPage(),
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

  Future loadProductLists(_ViewModel vm) async {
    try {
      var saveManager = ProductListsSaveManager(vm.store.state);
      var productLists = await saveManager.load();
      vm.store.dispatch(ReplaceProductListsAction(productLists: productLists));
    } catch (e) {
      print("Failed to load product lists data $e");
    }
  }

  Future loadUserData(_ViewModel vm) async {
    final userManager = UserManager(store: vm.store);
    await userManager.loadUserFromFile();
  }

  Future<UserStatus> verifyUser(_ViewModel vm) async {
    final userManager = UserManager(store: vm.store, currentUser: vm.store.state.currentUser);
    return await userManager.verifyUser();
  }

  Future onFirstLoad(BuildContext context, _ViewModel vm) async {
    await loadUserData(vm);
    if (vm.store.state.currentUser == null) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) => UserLoginScreen()));
    } else {
      final status = await verifyUser(vm);
      if (status == UserStatus.loggoutOut) {
        await Navigator.push(context, MaterialPageRoute(builder: (context) => UserLoginScreen()));
      } else if (status == UserStatus.banned) {
        await showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: Text("Notandi hefur verið bannaður"),
            );
          }
        );
        await Navigator.push(context, MaterialPageRoute(builder: (context) => UserLoginScreen()));
      }
    }
    await loadProductData(context, vm);
    await loadProductLists(vm);
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
                  onFirstLoad(context, vm);
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
                  icon: Icon(Icons.access_alarm), title: Text("Stimpla")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), title: Text("Stillingar")),
            ], 
            currentIndex: currentIndex,
            onTap: onTabTap,
            type: BottomNavigationBarType.fixed,
            ),
          );
        });
  }
}

class _ViewModel {
  final Store<AppState> store;
  final bool appReady;
  final User currentUser;
  final ProductDataSearchResult productSearchResult;

  _ViewModel({
    @required this.store,
    @required this.appReady,
    @required this.currentUser,
    @required this.productSearchResult,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      store: store,
      appReady: store.state.appReady,
      currentUser: store.state.currentUser,
      productSearchResult: store.state.productSearchResult,
    );
  }
}
