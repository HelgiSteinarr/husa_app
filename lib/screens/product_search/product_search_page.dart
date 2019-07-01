import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/screens/product_search/product_find_from_scan.dart';
import 'package:husa_app/utilities/common.dart';
import 'package:husa_app/widgets/SearchBarButton.dart';
import 'package:redux/redux.dart';
import 'product_info_screen.dart';
import '../../models/app_state.dart';
import '../../actions/product_data_actions.dart';
import '../../models/product_data.dart';

class ProductSearchPage extends StatefulWidget {
  ProductSearchPage({Key key}) : super(key: key);

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final searchTextController = TextEditingController();
  bool firstTime = true;
  IconData searchBarEndIcon = Icons.search;

  Future changeSearchTypes(BuildContext context, _ViewModel vm) async {
    List<ProductDataSearchType> searchTypes =
        List.from(vm.searchResult.searchTypes);

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Leita eftir"),
            content: _SearchTypesDialogList(searchTypes: searchTypes, vm: vm),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Breyta"),
                onPressed: () {
                  vm.store.dispatch(SearchProductDataAction(
                    searchString: searchTextController.text,
                    searchTypes: searchTypes,
                  ));
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void openScanMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductFindFromScanScreen(
              onCodeFound: (Product product) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProductInfoScreen(product: product)));
              },
            ),
      ),
    );
  }

  // MARK: Build
  Widget buildSearchResult(BuildContext context, int position, _ViewModel vm) {
    var product = vm.productData[vm.searchResult.productIndexes[position]];
    return ListTile(
      title: Text(product.name),
      subtitle: Text(product.productNumber),
      trailing: Text(
        fromatPrice(product.price),
        style: TextStyle(color: Colors.red),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductInfoScreen(product: product)));
      },
    );
  }

  Widget buildPopupMenuButton(BuildContext context, _ViewModel vm) {
    final productDataLoaded = vm.productData.length > 0;

    return PopupMenuButton<int>(
      child: SearchBarButton(
        icon: Icons.list,
        enabled: productDataLoaded,
      ),
      onSelected: productDataLoaded
          ? (int position) {
              switch (position) {
                case 0:
                  changeSearchTypes(context, vm);
                  break;
                case 1:
                  openScanMenu(context);
                  break;
              }
            }
          : null,
      itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 0,
              child: Text("Leita eftir"),
            ),
            PopupMenuItem(
              value: 1,
              child: Text("Nota skanna"),
            )
          ],
    );
  }

  Widget buildSearchBox(BuildContext context, _ViewModel vm) {
    final productDataLoaded = vm.productData.length > 0;

    return Container(
      height: 45,
      child: Row(
        children: <Widget>[
          buildPopupMenuButton(context, vm),
          Expanded(
              child: TextField(
            controller: searchTextController,
            decoration: InputDecoration(
              hintText: "Leita",
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
            ),
            enabled: productDataLoaded,
            style: TextStyle(),
          )),
          SearchBarButton(
            icon: searchBarEndIcon,
            enabled: productDataLoaded,
            onTap: () {
              if (searchBarEndIcon == Icons.close) {
                searchTextController.text = "";
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
        ],
      ),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, spreadRadius: 2.0, blurRadius: 2.0)
      ]),
    );
  }

  Widget buildBody(BuildContext context, _ViewModel vm) {
    if (vm.productData.length > 0) {
      return Container(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.black26,
                );
              },
              itemCount: vm.searchResult.productIndexes.length,
              itemBuilder: (BuildContext context, int position) =>
                  buildSearchResult(context, position, vm),
            )),
          ],
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          if (firstTime) {
            searchTextController.text = vm.searchResult.searchString;
            searchTextController.addListener(() {
              if (searchTextController.text == "") {
                searchBarEndIcon = Icons.search;
              } else {
                searchBarEndIcon = Icons.close;
              }
              vm.store.dispatch(SearchProductDataAction(
                searchString: searchTextController.text,
                searchTypes: vm.searchResult.searchTypes,
              ));
            });

            if (searchTextController.text != "") {
              searchBarEndIcon = Icons.close;
            }

            firstTime = false;
          }

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: buildSearchBox(context, vm),
            ),
            body: buildBody(context, vm),
          );
        });
  }
}

class _SearchTypesDialogList extends StatefulWidget {
  _SearchTypesDialogList({
    Key key,
    this.searchTypes,
    this.vm,
  }) : super(key: key);

  final List<ProductDataSearchType> searchTypes;
  final _ViewModel vm;

  @override
  _SearchTypesDialogListState createState() => _SearchTypesDialogListState();
}

class _SearchTypesDialogListState extends State<_SearchTypesDialogList> {
  List<ProductDataSearchType> searchTypes;

  @override
  void initState() {
    super.initState();
    searchTypes = widget.searchTypes;
  }

  Widget buildListTile(String title, ProductDataSearchType type) {
    return CheckboxListTile(
      title: Text(title),
      value: searchTypes.contains(type),
      onChanged: (newValue) {
        setState(() {
          if (!newValue && searchTypes.contains(type)) {
            searchTypes.remove(type);
          }
          if (newValue && !searchTypes.contains(type)) {
            searchTypes.add(type);
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          buildListTile("Vörunúmeri", ProductDataSearchType.productNumber),
          buildListTile("Nafni", ProductDataSearchType.name),
          buildListTile("Lýsingu", ProductDataSearchType.description),
        ],
      ),
      height: 170.0,
    );
  }
}

class _ViewModel {
  final ProductDataSearchResult searchResult;
  final List<Product> productData;
  final Store<AppState> store;

  _ViewModel({
    @required this.searchResult,
    @required this.productData,
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      searchResult: store.state.productSearchResult,
      productData: store.state.productData,
      store: store,
    );
  }
}
