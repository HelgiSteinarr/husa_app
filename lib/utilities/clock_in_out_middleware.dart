import 'dart:convert';
import 'dart:math';

import 'package:husa_app/utilities/common.dart';
import 'package:redux/redux.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import '../actions/clock_in_out_actions.dart';
import '../actions/history_item_actions.dart';
import '../models/history_item.dart';
import '../models/app_state.dart';

Middleware<AppState> createClockInOutMiddleware() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is ClockInOutAction) {
      try {
        final postId = randomString(32);
        final params =
            "?postId=$postId&SSN=${action.ssn}&unitId=-1";
        final response = await http.get(
            "https://register.husa.mytimeplan.com/register_ajax.php$params");
        final Map jsonObject = json.decode(response.body);
        final document = parse(jsonObject["history"]);

        final timeElements = document.getElementsByClassName("time");
        final nameElements = document.getElementsByClassName("name");
        final stateElements = document.getElementsByClassName("state");

        List<HistoryItem> historyItems = List();

        for (var i = 0; i < timeElements.length; i++) {
          historyItems.add(HistoryItem(
            time: timeElements[i].innerHtml,
            name: nameElements[i].innerHtml,
            state: stateElements[i].innerHtml,
          ));
        }

        store.dispatch(UpdateHistoryBoxItemsAction(historyItems: historyItems));
      } catch (e) {
        print("Failed to clock in/out");
        print(e);
      }
    }
    next(action);
  };
}
