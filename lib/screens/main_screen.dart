
import 'package:flutter/material.dart';
import 'package:husa_app/screens/product_lists/product_lists_page.dart';
import 'package:husa_app/screens/product_search/product_search_page.dart';
import 'package:husa_app/screens/settings/settings_page.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final List<Widget> pages = [
    ProductSearchPage(),
    ProductListsPage(),
    SettingsPage(),
  ];

  int currentIndex = 0;

  void onTabTap(int index)
  {
    setState(() {
      currentIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.search), title: Text("Vöruflettir")),
        BottomNavigationBarItem(
            icon: Icon(Icons.assignment), title: Text("Vörulistar")),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings), title: Text("Stillingar")),
      ], currentIndex: currentIndex, onTap: onTabTap),
    );
  }
}