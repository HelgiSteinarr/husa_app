import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:husa_app/screens/product_lists/product_list_screen.dart';
import 'package:redux/redux.dart';
import '../../models/app_state.dart';
import '../../actions/product_actions.dart';
import '../../models/product.dart';

class ProductListsPage extends StatelessWidget {
  ProductListsPage({Key key}) : super(key: key);

  Future<String> getInputForProductName(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    String result;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Nafn"),
            content: TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(hintText: "Nafn"),
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
                  result = nameController.text;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return result;
  }

  Future<bool> confirmDeletion(BuildContext context, ProductList productList) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Eyða lista"),
            content: Text("Ertu viss um að þú viljir eyða ${productList.name}?"),
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

  void addProductList(_ViewModel vm, BuildContext context) async {
    var name = await getInputForProductName(context);
    if (name == null) return;
    vm.store.dispatch(AddProductListAction(name: name));
    vm.store.dispatch(SaveProductListsAction());
  }

  void deleteProductList(_ViewModel vm, BuildContext context, int index) async {
    if (await confirmDeletion(context, vm.productLists[index])) {
      vm.store.dispatch(DeleteProductListAction(index: index));
      vm.store.dispatch(SaveProductListsAction());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        // Rather than build a method here, we'll defer this
        // responsibilty to the _viewModel.
        converter: _ViewModel.fromStore,
        // Our builder now takes in a _viewModel as a second arg
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            appBar: AppBar(title: Text("Vörulistar")),
            body: ListView.builder(
              itemCount: vm.productLists.length,
              itemBuilder: (context, position) {
                var productCount = vm.productLists[position].list.length;
                return ListTile(
                  title: Text(vm.productLists[position].name),
                  subtitle: Text(
                      "Inniheldur ${(productCount == 1) ? 'eina vöru' : productCount.toString() + ' vörur'}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListScreen(
                                  index: position,
                                )));
                  },
                  onLongPress: () {
                    deleteProductList(vm, context, position);
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                addProductList(vm, context);
              },
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
