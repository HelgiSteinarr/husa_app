import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:husa_app/utilities/product_data_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../widgets/UpdateDataDialog.dart';
import '../../models/app_state.dart';
import '../../models/product.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void templUploadProductLists(_ViewModel vm) async {
    // var jsonObject = vm.productLists.map((i) => i.toJsonObject()).toList();
    // var jsonText = json.encode(jsonObject);
    final directory = await getApplicationDocumentsDirectory();
    FormData formData = new FormData.from({
      "key": "5sAg858S!s",
      "file": new UploadFileInfo(
          File('${directory.path}/productLists.json'), "productLists.json")
    });
    var response = await Dio()
        .post("https://gudmunduro.com/vorulistar/upload.php", data: formData);
    // var response = await http.post("https://gudmunduro.com/vorulistar/upload.php", body: jsonText);
    print(response);
  }

  Future showUpdateProductDataView(BuildContext context, _ViewModel vm) async {
    var oldContext = context;

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UpdateProductDataDialog(
            store: vm.store,
            onFinished: (success) {
              var message = (success)
                  ? "Tókst að uppfæra gögn frá síðu"
                  : "Tókst ekki að uppfæra gögn frá síðu";
              Scaffold.of(oldContext)
                  .showSnackBar(SnackBar(content: Text(message)));
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        // Rather than build a method here, we'll defer this
        // responsibilty to the _viewModel.
        converter: _ViewModel.fromStore,
        // Our builder now takes in a _viewModel as a second arg
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            appBar: AppBar(title: Text("Stillingar")),
            body: ListView(
              children: <Widget>[
                ListTile(
                  title: Text("Uppfæra vörur frá síðu"),
                  onTap: () {
                    showUpdateProductDataView(context, vm);
                  },
                ),
                ListTile(
                  title: Text("Uploada vöurlistum",
                      style: TextStyle(color: Colors.red)),
                  onTap: () {
                    templUploadProductLists(vm);
                  },
                ),
              ],
            ),
          );
        });
  }
}

class _ViewModel {
  final List<ProductList> productLists;
  final Store<AppState> store;

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
