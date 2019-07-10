import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'user_create_screen.dart';
import '../../models/user.dart';
import '../../models/app_state.dart';
import '../../widgets/WaitDialog.dart';
import '../../widgets/SimpleAlertDialog.dart';
import '../../utilities/user_manager.dart';

class UserLoginScreen extends StatefulWidget {
  UserLoginScreen({Key key}) : super(key: key);

  @override
  _UserLoginScreenState createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future login(BuildContext context, _ViewModel vm) async {
    final userManager = UserManager(store: vm.store);
    await userManager.login(usernameController.text, passwordController.text);
    if (vm.store.state.currentUser != null) Navigator.pop(context);
    else {
      await showDialog(
          context: context,
          builder: (context) {
            return SimpleAlertDialog(
              title: Text("Innskráning tókst ekki"),
            );
          }
        );
    }
  }

  Future createAccount(BuildContext context, _ViewModel vm) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserCreateScreen()));
    if (vm.store.state.currentUser != null) {
      Navigator.pop(context);
    }
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
                                textAlign: TextAlign.center,
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
                                    onPressed: () => login(context, vm),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 12.0, right: 12.0),
                                  ),
                                  RaisedButton(
                                    child: Text("Nýskrá"),
                                    onPressed: () => createAccount(context, vm),
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
            body: buildBody(context, vm),
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
