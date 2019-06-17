import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import '../../models/app_state.dart';
import '../../actions/product_actions.dart';
import '../../models/product.dart';

class ProductListAddFromScanScreen extends StatefulWidget {
  ProductListAddFromScanScreen({Key key, this.index}) : super(key: key);

  final int index;

  @override
  _ProductListAddFromScanScreenState createState() => _ProductListAddFromScanScreenState();

}

class _ProductListAddFromScanScreenState extends State<ProductListAddFromScanScreen> {

  String currentCode = "";
  int verifyCounter = 0;

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

  void addProductToList(_ViewModel vm, BuildContext context, String productNumber) async {
    if (productNumber == null) return;
    var count = await getInputForCount(context);
    if (count == null) return;
    vm.store.dispatch(AddToProductListAction(
        productNumber: productNumber, count: count, index: widget.index));
    vm.store.dispatch(SaveProductListsAction());
  }

  Column buildBody(_ViewModel vm, BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 600,
          child: QrCamera(
            qrCodeCallback: (String code) {
              setState(() {
                currentCode = code;
              });
            },
          ),
        ),
        Text(
          currentCode,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold
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
          var productList = vm.productLists[widget.index];
          return Scaffold(
            appBar: AppBar(
              title: Text(productList.name), 
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: buildBody(vm, context),
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
