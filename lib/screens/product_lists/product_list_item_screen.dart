import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:redux/redux.dart';
import '../../models/app_state.dart';
import '../../actions/product_actions.dart';
import '../../models/product.dart';
import '../product_search/product_info_screen.dart';

class ProductListItemScreen extends StatefulWidget {
  ProductListItemScreen({Key key, this.listIndex, this.itemIndex})
      : super(key: key);

  final int listIndex;
  final int itemIndex;

  @override
  _ProductListItemScreenState createState() => _ProductListItemScreenState();
}

class _ProductListItemScreenState extends State<ProductListItemScreen> {
  final TextEditingController productNumberTextController =
      TextEditingController();
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

  Product findProductFromListItem(String productNumber, _ViewModel vm) {
    var result = vm.productList
        .where((item) => item.productNumber == productNumber)
        .toList();
    if (result.length > 0) return result.first;
    return null;
  }

  Widget buildBody(
      BuildContext context, ProductListItem productListItem, _ViewModel vm) {
    var product = findProductFromListItem(productListItem.productNumber, vm);
    return ListView(
      children: <Widget>[
        Visibility(
          visible: (product != null),
          child: ListTile(
            title: Text("Upplýsingar um vöru"),
            subtitle: Text(product?.name ?? ""),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductInfoScreen(product: product)));
            },
          ),
        ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          var productListItem =
              vm.productLists[widget.listIndex].list[widget.itemIndex];
          if (!controllersTextSet) {
            productNumberTextController.text =
                productListItem.productNumber ?? "";
            countTextController.text = (productListItem.count ?? 1).toString();
            noteTextController.text = productListItem.note ?? "";
            controllersTextSet = true;
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(productListItem.productNumber),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.save),
                    tooltip: "Vista breytingar",
                    onPressed: () {
                      save(vm);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
              body: buildBody(context, productListItem, vm));
        });
  }
}

class _ViewModel {
  List<ProductList> productLists;
  List<Product> productList;
  Store<AppState> store;

  _ViewModel({
    @required this.productLists,
    @required this.productList,
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      productLists: store.state.productLists,
      productList: store.state.productList,
      store: store,
    );
  }
}
