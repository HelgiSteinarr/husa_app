import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import '../../models/user.dart';
import '../../models/mtp_data.dart';
import '../../models/app_state.dart';
import '../../actions/clock_in_out_actions.dart';

class ClockPage extends StatefulWidget {
  ClockPage({Key key}) : super(key: key);

  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  void clockInOut(_ViewModel vm) {
    vm.store.dispatch(ClockInOutAction(ssn: vm.mtpData.ssn));
  }

  String historyItemLabelText(_ViewModel vm) {
    if (vm.mtpData.historyItems.length == 0) {
      return "";
    }
    final firstHistoryItem = vm.mtpData.historyItems.first;
    return "${firstHistoryItem.time}  ${firstHistoryItem.name}  ${firstHistoryItem.state}";
  }

  bool shouldDisableClockInOutButton(_ViewModel vm) {
    return vm.mtpData.ssn == null;
  }

  Widget buildBody(BuildContext context, _ViewModel vm) {
    return Column(
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
          title: Text(vm.currentUser.name ?? "Nafn ekki skráð"),
          subtitle: Text(vm.mtpData.ssn ?? "Kennitala ekki skráð"),
        ),
        RaisedButton(
          child: Text("Stimpla inn/út"),
          color: Colors.red,
          textColor: Colors.white,
          onPressed:
              shouldDisableClockInOutButton(vm) ? null : () => clockInOut(vm),
        ),
        Text(historyItemLabelText(vm)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            appBar: AppBar(title: Text("Stimpla")),
            body: buildBody(context, vm),
          );
        });
  }
}

// MARK: View model
class _ViewModel {
  MtpData mtpData;
  User currentUser;
  Store<AppState> store;

  _ViewModel({
    @required this.mtpData,
    @required this.currentUser,
    @required this.store,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      mtpData: store.state.mtpData,
      currentUser: store.state.currentUser,
      store: store,
    );
  }
}
