import 'package:flutter/material.dart';
import 'package:husa_app/models/product_data.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import '../../models/app_state.dart';

enum _ProductCodeScanStatus {
  notProcessed,
  found,
  notFound,
}

class ProductFindFromScanScreen extends StatefulWidget {
  ProductFindFromScanScreen({Key key, this.onCodeFound}) : super(key: key);

  Function(Product product) onCodeFound;

  @override
  _ProductFindFromScanScreenState createState() => _ProductFindFromScanScreenState();

}

class _ProductFindFromScanScreenState extends State<ProductFindFromScanScreen> {

  String currentCode = "";
  _ProductCodeScanStatus status = _ProductCodeScanStatus.notProcessed;

  Future onCodeUpdate(_ViewModel vm, BuildContext context) async {
    var result = vm.productData.where((product) => product.productNumber == currentCode);
    if (result.length > 0) {
      setState(() {
        status = _ProductCodeScanStatus.found;
      });
      Navigator.of(context).pop();
      if (widget.onCodeFound != null) {
        widget.onCodeFound(result.first);
      }
    } else {
      setState(() {
        status = _ProductCodeScanStatus.notFound;
      });
    }
  }

  Column buildBody(_ViewModel vm, BuildContext context) {
    Color codeColor;
    switch (status) {
      case _ProductCodeScanStatus.notProcessed:
        codeColor = Colors.black45;
        break;
      case _ProductCodeScanStatus.found:
        codeColor = Colors.green;
        break;
      case _ProductCodeScanStatus.notFound:
        codeColor = Colors.red;
        break;
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: QrCamera(
            qrCodeCallback: (String code) {
              if (code == currentCode) return;
              var oldCode = currentCode;
              setState(() {
                currentCode = code;
                status = _ProductCodeScanStatus.notProcessed;
              });
              if (oldCode != currentCode) {
                onCodeUpdate(vm, context);
              }
            },
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              currentCode,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: codeColor,
                fontSize: 30.0,
              ),
            )
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        builder: (BuildContext context, _ViewModel vm) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Skanni"), 
              leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: buildBody(vm, context),
          );
        });
  }
}

class _ViewModel {
  List<Product> productData;

  _ViewModel({
    @required this.productData,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      productData: store.state.productData,
    );
  }
}
