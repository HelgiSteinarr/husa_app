import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:husa_app/screens/product_lists/product_list_screen.dart';
import 'package:redux/redux.dart';
import '../../models/app_state.dart';
import '../../actions/product_list_actions.dart';
import '../../models/product_list.dart';
import '../../widgets/ConfirmDialog.dart';
import '../../widgets/TextInputDialog.dart';

class ProductListsPage extends StatelessWidget {
  ProductListsPage({Key key}) : super(key: key);

  Future<String> getInputForProductName(BuildContext context) async {
    String result;

    await showDialog(
        context: context,
        builder: (context) {
          return TextInputDialog(
            title: "Nafn",
            hint: "Nafn",
            confirmText: "Bæta við",
            cancelText: "Hætta við",
            onFinish: (shouldAdd, name) {
              if (shouldAdd) result = name;
            },
          );
        });
    return result;
  }

  Future<bool> confirmDeletion(
      BuildContext context, ProductList productList) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: "Eyða lista",
            body: "Ertu viss um að þú viljir eyða ${productList.name}?",
            confirmButtonText: "Eyða",
            cancelButtonText: "Hætta við",
            warning: true,
            onAccept: () => result = true,
            onDeny: () => result = false,
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

  Widget buildListTile(BuildContext context, int position, _ViewModel vm) {
    var productCount = vm.productLists[position].list.length;

    return ListTile(
      leading: SizedBox(
        width: 40.0,
        height: 40.0,
        child: Center(child: Icon(Icons.assignment, size: 30.0)),
      ),
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
            body: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.black26,
                );
              },
              itemCount: vm.productLists.length,
              itemBuilder: (context, position) {
                return buildListTile(context, position, vm);
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
