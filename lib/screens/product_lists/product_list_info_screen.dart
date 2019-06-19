import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:redux/redux.dart';
import '../../models/app_state.dart';
import '../../actions/product_list_actions.dart';
import '../../models/product_list.dart';

class ProductListInfoScreen extends StatefulWidget {
  ProductListInfoScreen({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _ProductListInfoScreenState createState() => _ProductListInfoScreenState();
}

class _ProductListInfoScreenState extends State<ProductListInfoScreen> {

  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController noteTextController = TextEditingController();

  bool controllersTextSet = false;

  void save(_ViewModel vm) {
    var updateAction = UpdateProductListAction(
      index: widget.index,
      name: nameTextController.text ?? "",
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
          var productList = vm.productLists[widget.index];
          if (!controllersTextSet) {
            nameTextController.text = productList.name ?? "";
            noteTextController.text = productList.note ?? "";
            controllersTextSet = true;
          }

          return Scaffold(
            appBar: AppBar(
              title: Text("Upplýsingar um lista"),
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
                    controller: nameTextController,
                    decoration: InputDecoration(
                      labelText: "Nafn",
                    ),
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
