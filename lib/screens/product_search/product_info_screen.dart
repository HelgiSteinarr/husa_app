import 'package:flutter/material.dart';
import 'package:husa_app/utilities/common.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/product.dart';

class ProductInfoScreen extends StatelessWidget {
  ProductInfoScreen({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upplýsingar um vöru")),
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(children: <Widget>[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      product.name,
                      style: TextStyle(fontSize: 20.0),
                    )),
                Padding(
                  padding: EdgeInsets.all(2.0),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          product.description,
                          style:
                              TextStyle(fontSize: 14.0, color: Colors.black54),
                        ))),
              ])),
          Padding(
              padding: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Vörunúmer: " + product.productNumber))),
          Padding(
              padding: EdgeInsets.only(left: 10.0, top: 5.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    fromatPrice(product.price),
                    style: TextStyle(fontSize: 20.0, color: Colors.red),
                  ))),
          ListTile(
            title: Text(
              "Opna á vefsíðu",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () async {
              final url = "https://husa.is/${product.url}";
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text("Tókst ekki að opna á vefsíðu")));
              }
            },
          )
        ],
      ),
    );
  }
}
