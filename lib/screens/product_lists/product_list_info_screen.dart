import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:husa_app/actions/app_actions.dart';
import 'package:husa_app/widgets/ColorLabelIcon.dart';
import 'package:husa_app/widgets/ConfirmDialog.dart';
import 'package:husa_app/widgets/TextInputDialog.dart';
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

  Future<String> selectLabelName(BuildContext context) async {
    String result;

    await showDialog(
        context: context,
        builder: (context) {
          return TextInputDialog(
            title: "Veldu nafn á merki",
            hint: "Nafn á merki",
            confirmText: "Bæta við",
            cancelText: "Hætta við",
            onFinish: (shouldAdd, labelName) {
              if (shouldAdd) result = labelName;
            },
          );
        });
    return result;
  }

  Future<int> selectLabelColor(BuildContext context, _ViewModel vm) async {
    int result;

    Map<Color, String> colorNames = {
      Colors.black45: "Grár",
      Colors.red: "Rauður",
      Colors.orange: "Appelsínugulur",
      Colors.deepOrange: "Dökk appelsínugulur",
      Colors.yellow: "Gulur",
      Colors.cyan: "Ljósblár",
      Colors.green: "Grænn",
      Colors.blue: "Blár"
    };

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Veldu lit á merki"),
            content: Container(
              height: 392,
              child: Column(
              children: ColorLabel.labelColors.map((color) {
                if (color == Colors.black45) return Container();
                return ListTile(
                  leading: Container(
                    width: 40.0,
                    height: 40.0,
                    child: Center(
                        child: ColorLabelIcon(
                            label: ColorLabel(
                                colorIndex:
                                    ColorLabel.labelColors.indexOf(color)))),
                  ),
                  title: Text(colorNames[color]),
                  onTap: () {
                    result = ColorLabel.labelColors.indexOf(color);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              )
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

  Future<bool> confirmDeleteLabel(
      BuildContext context, ColorLabel label) async {
    bool result = false;

    await showDialog(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: "Eyða merki",
            body:
                "Ertu viss um að þú viljir eyða ${label.text}?",
            confirmButtonText: "Eyða",
            cancelButtonText: "Hætta við",
            warning: true,
            onAccept: () => result = true,
            onDeny: () => result = false,
          );
        });
    return result;
  }

  void save(_ViewModel vm) {
    var updateAction = UpdateProductListAction(
      index: widget.index,
      name: nameTextController.text ?? "",
      note: noteTextController.text,
    );

    vm.store.dispatch(updateAction);
    vm.store.dispatch(SaveProductListsAction());
  }

  Future addLabel(BuildContext context, _ViewModel vm) async {
    var lableName = await selectLabelName(context);
    if (lableName == null) return;
    var labelColorIndex = await selectLabelColor(context, vm);
    if (labelColorIndex == null) return;

    vm.store.dispatch(AddProductListLabelAction(
      listIndex: widget.index,
      label: ColorLabel(
        text: lableName,
        colorIndex: labelColorIndex,
      ),
    ));
    vm.store.dispatch(SaveProductListsAction());
  }

  Future deleteLabel(BuildContext context, _ViewModel vm, int labelIndex, ColorLabel label) async {
    if (!(await confirmDeleteLabel(context, label))) return;
    vm.store.dispatch(DeleteProductListLabelAction(
      listIndex: widget.index,
      labelIndex: labelIndex,
    ));
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
              ],
            ),
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text("Merki", style: TextStyle(fontSize: 20.0)),
                ),
                Column(
                  children: productList.labels.map((label) {
                    return ListTile(
                      leading: Container(
                        width: 40.0,
                        height: 40.0,
                        child: Center(child: ColorLabelIcon(label: label)),
                      ),
                      title: Text(label.text),
                      onLongPress: () {
                        deleteLabel(context, vm, productList.labels.indexOf(label), label);
                      },
                    );
                  }).toList()
                    ..add(ListTile(
                      title: Text("Bæta við", textAlign: TextAlign.center),
                      onTap: () async {
                        await addLabel(context, vm);
                      },
                    )),
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
