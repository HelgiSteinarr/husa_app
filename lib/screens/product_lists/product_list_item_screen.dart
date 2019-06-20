import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:husa_app/widgets/ColorLabelIcon.dart';
import 'package:redux/redux.dart';
import '../../models/app_state.dart';
import '../../actions/product_list_actions.dart';
import '../../models/product_list.dart';
import '../../models/product_data.dart';
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
  int labelIndex;

  bool controllersTextSet = false;

  Future<int> selectOtherList(BuildContext context, _ViewModel vm) async {
    /* Returns list index */
    int result;

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Veldu lista"),
            content: Column(
              children: vm.productLists.map((item) {
                return ListTile(
                  title: Text(item.name),
                  onTap: () {
                    result = vm.productLists.indexOf(item);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við", style: TextStyle(color: Colors.black)),
                splashColor: Colors.black26,
                highlightColor: Colors.black12,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return result;
  }

  Future<int> selectLabel(BuildContext context, _ViewModel vm) async {
    int result;
    var productList = vm.productLists[widget.listIndex];

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Veldu merki"),
            content: Column(
              children: productList.labels.map((label) {
                return ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                      child: ColorLabelIcon(label: label),
                    ),
                  ),
                  title: Text(label.text),
                  onTap: () {
                    result = productList.labels.indexOf(label);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Hætta við", style: TextStyle(color: Colors.black)),
                splashColor: Colors.black26,
                highlightColor: Colors.black12,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
    return result;
  }

  void save(_ViewModel vm) {
    var updateAction = UpdateProductListItemAction(
      listIndex: widget.listIndex,
      itemIndex: widget.itemIndex,
      newProductListItem: ProductListItem(
        productNumber: productNumberTextController.text ?? "",
        count: int.parse(countTextController.text ?? "1") ?? 1,
        note: noteTextController.text,
        labelIndex: labelIndex,
      ),
    );

    vm.store.dispatch(updateAction);
    vm.store.dispatch(SaveProductListsAction());
  }

  Product findProductFromListItem(String productNumber, _ViewModel vm) {
    var result = vm.productData
        .where((item) => item.productNumber == productNumber)
        .toList();
    if (result.length > 0) return result.first;
    return null;
  }

  Future copyItem(BuildContext context, _ViewModel vm) async {
    var selectedListIndex = await selectOtherList(context, vm);
    if (selectedListIndex == null) return;
    vm.store.dispatch(CopyProductListItemAction(
      originalListIndex: widget.listIndex,
      targetListIndex: selectedListIndex,
      itemIndex: widget.itemIndex,
    ));
    vm.store.dispatch(SaveProductListsAction());
  }

  Future moveItem(BuildContext context, _ViewModel vm) async {
    var selectedListIndex = await selectOtherList(context, vm);
    if (selectedListIndex == null) return;
    Navigator.pop(context);
    vm.store.dispatch(MoveProductListItemAction(
      originalListIndex: widget.listIndex,
      targetListIndex: selectedListIndex,
      itemIndex: widget.itemIndex,
    ));
    vm.store.dispatch(SaveProductListsAction());
  }

  Future setLabel(BuildContext context, _ViewModel vm) async {
    int labelIndex = await selectLabel(context, vm);
    if (labelIndex == null) return;
    setState(() {
      this.labelIndex = labelIndex;
    });
  }

  Widget buildBody(
      BuildContext context, ProductListItem productListItem, _ViewModel vm) {
    var product = findProductFromListItem(productListItem.productNumber, vm);
    var productList = vm.productLists[widget.listIndex];

    ColorLabel label;
    if (productList.labels != null &&
        labelIndex != null &&
        productList.labels.length > labelIndex) {
      label = productList.labels[labelIndex];
    } else {
      label = ColorLabel(colorIndex: 0, text: null);
    }

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
        ListTile(
          leading: Container(
            width: 40.0,
            height: 40.0,
            child: Center(child: ColorLabelIcon(label: label)),
          ),
          title: Text("Skipta um merki"),
          subtitle: Text(label.text ?? "Ekkert valið"),
          onTap: () async {
            await setLabel(context, vm);
          },
        ),
        ListTile(
          title: Text("Færa"),
          onTap: () async {
            await moveItem(context, vm);
          },
        ),
        ListTile(
          title: Text("Afrita"),
          onTap: () async {
            await copyItem(context, vm);
          },
        ),
        Divider(
          color: Colors.black26,
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
            labelIndex = productListItem.labelIndex;
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
