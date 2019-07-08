import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'settings_info_page.dart';
import 'settings_account_screen.dart';

import '../../utilities/product_data_manager.dart';
import '../../widgets/UpdateDataDialog.dart';
import '../../models/product_list.dart';
import '../../widgets/WaitDialog.dart';
import '../../models/app_state.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void templUploadProductLists(BuildContext context, _ViewModel vm) async {
    final directory = await getApplicationDocumentsDirectory();
    FormData formData = new FormData.from({
      "key": "5sAg858S!s",
      "file": new UploadFileInfo(
          File('${directory.path}/productLists.json'), "productLists.json")
    });
    Future<Response> response = Dio()
        .post("https://gudmunduro.com/vorulistar/upload.php", data: formData);
    await showDialog(
      context: context,
      builder: (context) => WaitDialog(waitFor: response),
    );
    var responseValue = await response;
    Map jsonResponse = jsonDecode(responseValue.data);

    if (jsonResponse != null &&
        jsonResponse.containsKey("error") &&
        jsonResponse["error"] == 0) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Tókst að setja vörulista á síðu")));
    } else {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text("Tókst ekki að setja vörulista á síðu")));
    }
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
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          final List<_SettingsItem> settingsItems = [
            _SettingsItem(
              title: "Aðgangur",
              onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsAccountScreen()));
              }
            ),
            _SettingsItem(
                title: "Uppfæra vörur frá síðu (husa.is)",
                onTap: () {
                  showUpdateProductDataView(context, vm);
                }),
            _SettingsItem(
                title: "Setja vörulista á síðu",
                onTap: () {
                  templUploadProductLists(context, vm);
                }),
            _SettingsItem(
                title: "Um þetta app",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsInfoPage()));
                }),
          ];

          return Scaffold(
            appBar: AppBar(title: Text("Stillingar")),
            body: ListView.separated(
              separatorBuilder: (context, position) {
                return Divider(
                  color: Colors.black26,
                );
              },
              itemCount: settingsItems.length,
              itemBuilder: (context, position) {
                return ListTile(
                  title: Text(settingsItems[position].title),
                  onTap: settingsItems[position].onTap,
                );
              },
            ),
          );
        });
  }
}

// MARK: SettingsItem
class _SettingsItem {
  String title;
  Function onTap;

  _SettingsItem({
    this.title,
    this.onTap,
  });
}

// MARK: ViewModel
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
