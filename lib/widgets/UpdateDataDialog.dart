import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../utilities/product_data_manager.dart';
import '../models/app_state.dart';


class UpdateProductDataDialog extends StatefulWidget {
  UpdateProductDataDialog({Key key, this.store, this.onFinished}) : super(key: key);
  
  final Store<AppState> store;
  final Function(bool) onFinished;

  @override 
  _UpdateProductDataDialogState createState() => _UpdateProductDataDialogState();
}

class _UpdateProductDataDialogState extends State<UpdateProductDataDialog> {

  bool firstTime = true;

  Future updateProducts(BuildContext context) async {
    final productDataManager = ProductDataManager(store: widget.store);
    bool result = await productDataManager.update();
    print("Finished");
    print(result);
    Navigator.of(context).pop();
    widget.onFinished(result);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (firstTime) {
      updateProducts(context);
    }

    return AlertDialog(
      title: Text("Uppfæri vörur frá síðu"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Center(
          child: CircularProgressIndicator(),
      )),
      
    );
  }
}