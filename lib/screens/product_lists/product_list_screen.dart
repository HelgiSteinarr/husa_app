import 'package:flutter/material.dart';
import 'package:husa_app/screens/product_lists/product_list_add_from_scan_screen.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:husa_app/screens/product_lists/product_list_item_screen.dart';
import '../../models/app_state.dart';
import '../../actions/product_actions.dart';
import '../../models/product.dart';
import 'product_list_info_screen.dart';

class ProductListScreen extends StatelessWidget {
  ProductListScreen({Key key, this.index}) : super(key: key);

  final int index;

  Future<String> getInputForProductNumber(BuildContext context) async {
    TextEditingController productNumberController = TextEditingController();
    String result;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Vörunúmer"),
            content: TextField(
              autofocus: true,
              controller: productNumberController,
              decoration: InputDecoration(hintText: "Vörunúmer"),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                result = productNumberController.text;
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við"),
                onPressed: () {
                  result = null;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Bæta við"),
                onPressed: () {
                  result = productNumberController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return result;
  }

  Future<int> getInputForCount(BuildContext context) async {
    TextEditingController countController = TextEditingController();
    int result;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Fjöldi"),
            content: TextField(
              controller: countController,
              autofocus: true,
              decoration: InputDecoration(hintText: "Fjöldi"),
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                result = int.parse(countController.text);
                Navigator.of(context).pop();
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við"),
                onPressed: () {
                  result = null;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Bæta við"),
                onPressed: () {
                  result = int.parse(countController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
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
          return AlertDialog(
            title: Text("Eyða úr lista"),
            content: Text(
                "Ertu viss um að þú viljir eyða ${product.productNumber} úr lista?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við"),
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Eyða"),
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return result;
  }

  Future<bool> confirmDeleteAll(BuildContext context) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Eyða öllu úr lista"),
            content: Text("Ertu viss um að þú viljir eyða öllu úr listanum?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við"),
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Eyða"),
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return result;
  }

  void addProductToList(_ViewModel vm, BuildContext context) async {
    var productNumber = await getInputForProductNumber(context);
    if (productNumber == null) return;
    var count = await getInputForCount(context);
    if (count == null) return;
    vm.store.dispatch(AddToProductListAction(
        productNumber: productNumber, count: count, index: index));
    vm.store.dispatch(SaveProductListsAction());
  }

  void quickAddProductsToList(_ViewModel vm, BuildContext context) async {
    while (true) {
      var productNumber = await getInputForProductNumber(context);
      if (productNumber == null) return;
      var count = await getInputForCount(context);
      if (count == null) return;
      vm.store.dispatch(AddToProductListAction(
          productNumber: productNumber, count: count, index: index));
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

  Column buildBody(_ViewModel vm, ProductList productList) {
    return Column(
      children: <Widget>[
        (productList.note != null && productList.note != "")
            ? Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 10.0, bottom: 0.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(productList.note)))
            : Container(),
        Expanded(
          child: ListView.builder(
            itemCount: productList.list.length,
            itemBuilder: (context, position) {
              return ListTile(
                title: Text("${productList.list[position].productNumber}"),
                subtitle: Text("Magn ${productList.list[position].count}"),
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
  Store<AppState> store;

  _ViewModel({
    @required this.productLists,
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      productLists: store.state.productLists,
      store: store,
    );
  }
}
