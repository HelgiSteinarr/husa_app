import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:redux/redux.dart';
import '../../models/app_state.dart';
import '../../actions/product_actions.dart';
import '../../models/product.dart';

class ProductListItemScreen extends StatefulWidget {
  ProductListItemScreen({Key key, this.listIndex, this.itemIndex}) : super(key: key);

  final int listIndex;
  final int itemIndex;

  @override
  _ProductListItemScreenState createState() => _ProductListItemScreenState();
}

class _ProductListItemScreenState extends State<ProductListItemScreen> {

  final TextEditingController productNumberTextController = TextEditingController();
  final TextEditingController countTextController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  bool controllersTextSet = false;

  void save(_ViewModel vm) {
    var updateAction = UpdateProductListItemAction(
      listIndex: widget.listIndex,
      itemIndex: widget.itemIndex,
      productNumber: productNumberTextController.text ?? "",
      count: int.parse(countTextController.text ?? "1") ?? 1,
      note: noteTextController.text,
    );

    vm.store.dispatch(updateAction);
    vm.store.dispatch(SaveProductListsAction());
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        // Rather than build a method here, we'll defer this
        // responsibilty to the _viewModel.
        converter: _ViewModel.fromStore,
        // Our builder now takes in a _viewModel as a second arg
        builder: (BuildContext context, _ViewModel vm) {
          var product = vm.productLists[widget.listIndex].list[widget.itemIndex];
          if (!controllersTextSet) {
            productNumberTextController.text = product.productNumber ?? "";
            countTextController.text = (product.count ?? 1).toString();
            noteTextController.text = product.note ?? "";
            controllersTextSet = true;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(product.productNumber),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.save),
                  tooltip: "Vista breytingar",
                  onPressed: () {
                    save(vm);
                    Navigator.pop(context);
                  },
                )
              ],),
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: productNumberTextController,
                    decoration: InputDecoration(
                      labelText: "Vörunúmer",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: countTextController,
                    decoration: InputDecoration(
                      labelText: "Magn",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: noteTextController,
                    decoration: InputDecoration(
                      labelText: "Auka upplýsingar",
                    ),
                    maxLines: 5,
                  ),
                ),
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
