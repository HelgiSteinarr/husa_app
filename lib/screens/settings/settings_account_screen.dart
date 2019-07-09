import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'settings_account_create_screen.dart';
import '../../models/user.dart';
import '../../models/app_state.dart';
import '../../widgets/WaitDialog.dart';
import '../../utilities/user_manager.dart';

class SettingsAccountScreen extends StatefulWidget {
  SettingsAccountScreen({Key key}) : super(key: key);

  @override
  _SettingsAccountScreenState createState() => _SettingsAccountScreenState();
}

class _SettingsAccountScreenState extends State<SettingsAccountScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login(_ViewModel vm) {
    final userManager = UserManager(store: vm.store);
    userManager.login(usernameController.text, passwordController.text);
  }

  void logout(_ViewModel vm) {
    final userManager =
        UserManager(store: vm.store, currentUser: vm.currentUser);
    userManager.logout();
  }

  Future uploadProductLists(BuildContext context, _ViewModel vm) async {
    final userManager =
        UserManager(store: vm.store, currentUser: vm.currentUser);
    var result = userManager.uploadProductLists();
    await showDialog(
      context: context,
      builder: (context) => WaitDialog(waitFor: result),
    );
  }

  Widget buildAccountSignedOutBody(BuildContext context, _ViewModel vm) {
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
                    height: 300.0,
                    child: Padding(
                        padding: EdgeInsets.all(14.0),
                        child: ListView(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Innskráning",
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ),
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
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            ),
                            Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  RaisedButton(
                                    child: Text("Innskrá"),
                                    color: Colors.red,
                                    textColor: Colors.white,
                                    onPressed: () => login(vm),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                  ),
                                  RaisedButton(
                                    child: Text("Nýskrá"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SettingsAccountCreateScreen()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))))));
  }

  Widget buildAccountSignedInBody(BuildContext context, _ViewModel vm) {
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Container(
            width: 50.0,
            height: 50.0,
            child: Icon(
              Icons.person,
              size: 48.0,
            ),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          title: Text(vm.currentUser.name),
          subtitle: Text(vm.currentUser.username),
        ),
        ListTile(
          title: Text("Setja vörulista á síðu"),
          onTap: () => uploadProductLists(context, vm),
        ),
        ListTile(
          title: Text("Skrá út"),
          onTap: () => logout(vm),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            appBar: AppBar(),
            body: vm.currentUser != null
                ? buildAccountSignedInBody(context, vm)
                : buildAccountSignedOutBody(context, vm),
          );
        });
  }
}

// MARK: ViewModel
class _ViewModel {
  final User currentUser;
  final Store<AppState> store;

  _ViewModel({
    @required this.currentUser,
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      currentUser: store.state.currentUser,
      store: store,
    );
  }
}
