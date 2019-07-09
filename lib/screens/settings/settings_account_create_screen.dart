import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../models/user.dart';
import '../../models/app_state.dart';
import '../../widgets/WaitDialog.dart';
import '../../utilities/user_manager.dart';

class SettingsAccountCreateScreen extends StatefulWidget {
  SettingsAccountCreateScreen({Key key}) : super(key: key);

  @override
  _SettingsAccountCreateScreenState createState() => _SettingsAccountCreateScreenState();
}

class _SettingsAccountCreateScreenState extends State<SettingsAccountCreateScreen> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyPasswordController = TextEditingController();

  Future create(_ViewModel vm) async {
    final userManager = UserManager(store: vm.store);
    await userManager.create(nameController.text, usernameController.text, passwordController.text, verifyPasswordController.text);
    if (vm.store.state.currentUser != null) Navigator.pop(context);
  }

  Widget buildBody(BuildContext context, _ViewModel vm) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.red[800],
                Colors.red[400],
              ]),
        ),
        child: Center(
            child: Card(
                elevation: 4.0,
                child: Container(
                    width: 330.0,
                    height: 400.0,
                    child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Nýskrá",
                                style: TextStyle(fontSize: 24.0),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Center(
                                child: Container(
                                    width: 200.0,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          labelText: "Fullt nafn"),
                                      controller: nameController,
                                    ))),
                            Center(
                                child: Container(
                                    width: 200.0,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          labelText: "Notendanafn"),
                                      controller: usernameController,
                                    ))),
                            Center(
                                child: Container(
                                    width: 200.0,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          labelText: "Lykilorð"),
                                      controller: passwordController,
                                      obscureText: true,
                                    ))),
                            Center(
                                child: Container(
                                    width: 200.0,
                                    child: TextField(
                                      decoration: InputDecoration(
                                          labelText: "Endurtaka lykilorð"),
                                      controller: verifyPasswordController,
                                      obscureText: true,
                                    ))),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            ),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text("Nýskrá"),
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    onPressed: () => create(vm),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))))));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
                  appBar: AppBar(),
                  body: buildBody(context, vm),
                );
        }
    );
  }
}

// MARK: ViewModel
class _ViewModel {
  final Store<AppState> store;

  _ViewModel({
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      store: store,
    );
  }
}
