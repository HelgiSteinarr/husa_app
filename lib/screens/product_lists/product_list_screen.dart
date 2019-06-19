import 'package:flutter/material.dart';
import 'package:husa_app/screens/product_lists/product_list_add_from_scan_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:husa_app/screens/product_lists/product_list_item_screen.dart';
import 'product_list_info_screen.dart';
import '../../models/app_state.dart';
import '../../actions/product_list_actions.dart';
import '../../models/product_list.dart';
import '../../models/product_data.dart';
import '../../widgets/ConfirmDialog.dart';
import '../../widgets/TextInputDialog.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({Key key, this.index}) : super(key: key);

  final int index;

  Future<String> getInputForProductNumber(BuildContext context) async {
    String result;

    await showDialog(
        context: context,
        builder: (context) {
          return TextInputDialog(
            title: "Vörunúmer",
            hint: "Vörunúmer",
            keyboardType: TextInputType.number,
            confirmText: "Bæta við",
            cancelText: "Hætta við",
            onFinish: (shouldAdd, productNumber) {
              if (shouldAdd) result = productNumber;
            },
          );
        });
    return result;
  }

  Future<int> getInputForCount(BuildContext context) async {
    int result;

    await showDialog(
        context: context,
        builder: (context) {
          return TextInputDialog(
            title: "Fjöldi",
            hint: "Fjöldi",
            keyboardType: TextInputType.number,
            confirmText: "Bæta við",
            cancelText: "Hætta við",
            onFinish: (shouldAdd, count) {
              if (shouldAdd) {
                result = int.parse(count);
              }
            },
          );
        });
    return result;
  }

  Future<bool> confirmAlreadyInList(BuildContext context) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: "Vara nú þegar í listanum",
            body: "Varan er nú þegar í listanum.  Viltu samt bæta henni í?",
            confirmButtonText: "Bæta",
            cancelButtonText: "Hætta við",
            warning: true,
            onAccept: () => result = true,
            onDeny: () => result = false,
          );
        });
    return result;
  }

  Future<bool> confirmDeletion(
      BuildContext context, ProductListItem product) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: "Eyða úr lista",
            body:
                "Ertu viss um að þú viljir eyða ${product.productNumber} úr lista?",
            confirmButtonText: "Eyða",
            cancelButtonText: "Hætta við",
            warning: true,
            onAccept: () => result = true,
            onDeny: () => result = false,
          );
        });
    return result;
  }

  Future<bool> confirmDeleteAll(BuildContext context) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: "Eyða öllu úr lista",
            body: "Ertu viss um að þú viljir eyða öllu úr listanum?",
            confirmButtonText: "Eyða",
            cancelButtonText: "Hætta við",
            warning: true,
            onAccept: () => result = true,
            onDeny: () => result = false,
          );
        });
    return result;
  }

  void addProductToList(_ViewModel vm, BuildContext context) async {
    var productNumber = await getInputForProductNumber(context);
    if (productNumber == null) return;
    var count = await getInputForCount(context);
    if (count == null) return;
    if (vm.productLists[index].list
            .where((item) => item.productNumber == productNumber)
            .length >
        0) {
      if (!(await confirmAlreadyInList(context))) return;
    }
    vm.store.dispatch(AddToProductListAction(
        productListItem: ProductListItem(productNumber: productNumber, count: count, note: ""), index: index));
    vm.store.dispatch(SaveProductListsAction());
  }

  void quickAddProductsToList(_ViewModel vm, BuildContext context) async {
    while (true) {
      var productNumber = await getInputForProductNumber(context);
      if (productNumber == null) return;
      var count = await getInputForCount(context);
      if (count == null) return;
      if (vm.productLists[index].list
              .where((item) => item.productNumber == productNumber)
              .length >
          0) {
        if (!(await confirmAlreadyInList(context))) return;
      }
      vm.store.dispatch(AddToProductListAction(
        productListItem: ProductListItem(productNumber: productNumber, count: count, note: ""), index: index));
      vm.store.dispatch(SaveProductListsAction());
    }
  }

  void deleteFromList(_ViewModel vm, BuildContext context,
      ProductListItem product, int position) async {
    if (await confirmDeletion(context, product)) {
      vm.store.dispatch(
          DeleteProductListItemAction(listIndex: index, itemIndex: position));
      vm.store.dispatch(SaveProductListsAction());
    }
  }

  void deleteAllFromList(_ViewModel vm, BuildContext context) async {
    if (await confirmDeleteAll(context)) {
      vm.store.dispatch(DeleteAllProductListItemsAction(listIndex: index));
      vm.store.dispatch(SaveProductListsAction());
    }
  }

  String productNameFromNumber(String productNumber, _ViewModel vm) {
    var result = vm.productData
        .where((item) => item.productNumber == productNumber)
        .toList();
    if (result.length > 0) return result.first.name;
    return null;
  }

  Column buildBody(_ViewModel vm, ProductList productList) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: (productList.note != null && productList.note != ""),
          child: Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(productList.note ?? ""))),
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.black26,
              );
            },
            itemCount: productList.list.length,
            itemBuilder: (context, position) {
              var productListItem = productList.list[position];
              return ListTile(
                title: Text("${productListItem.productNumber}"),
                trailing: Text(
                  "${productListItem.count}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                subtitle: Text(
                    productNameFromNumber(productListItem.productNumber, vm) ??
                        "Ekki á síðu"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListItemScreen(
                              listIndex: index, itemIndex: position)));
                },
                onLongPress: () {
                  deleteFromList(
                      vm, context, productList.list[position], position);
                },
              );
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        // Rather than build a method here, we'll defer this
        // responsibilty to the _viewModel.
        converter: _ViewModel.fromStore,
        // Our builder now takes in a _viewModel as a second arg
        builder: (BuildContext context, _ViewModel vm) {
          var productList = vm.productLists[index];
          return Scaffold(
            appBar: AppBar(title: Text(productList.name), actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.info),
                  tooltip: "Upplýsingar um lista",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProductListInfoScreen(index: index)));
                  }),
              IconButton(
                  icon: Icon(Icons.clear_all),
                  tooltip: "Eyða öllu úr lista",
                  onPressed: () {
                    deleteAllFromList(vm, context);
                  }),
            ]),
            body: buildBody(vm, productList),
            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              curve: Curves.bounceIn,
              tooltip: "Bæta við vöru",
              children: <SpeedDialChild>[
                SpeedDialChild(
                    child: Icon(Icons.add),
                    label: "Bæta við einni",
                    backgroundColor: Colors.green,
                    onTap: () {
                      addProductToList(vm, context);
                    }),
                SpeedDialChild(
                  child: Icon(Icons.add),
                  label: "Bæta við mörgum",
                  backgroundColor: Colors.orange,
                  onTap: () {
                    quickAddProductsToList(vm, context);
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.add),
                  label: "Bæta við frá strikamerki",
                  backgroundColor: Colors.deepOrange,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ProductListAddFromScanScreen(index: index)));
                  },
                )
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  List<ProductList> productLists;
  List<Product> productData;
  Store<AppState> store;

  _ViewModel({
    @required this.productLists,
    @required this.productData,
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      productLists: store.state.productLists,
      productData: store.state.productData,
      store: store,
    );
  }
}
