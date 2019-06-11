import 'package:flutter/material.dart';
import 'package:material_component/page/FuliPage.dart';
import 'package:material_component/page/HomePage.dart';

import 'CategoryPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  var _index = 0;
  List<NavigView> navs;

  @override
  void initState() {
    navs = [
      NavigView(
          tabName: 'Main',
          tabIcon: Icon(Icons.home),
          tabBackground: Colors.deepPurple,
          tabPage: HomePage()),
      NavigView(
          tabName: 'MeiZi',
          tabIcon: Icon(Icons.photo_album),
          tabBackground: Colors.indigo,
          tabPage: FuliPage()),
      NavigView(
          tabName: 'Category',
          tabIcon: Icon(Icons.category),
          tabBackground: Colors.deepOrangeAccent,
          tabPage: CategoryPage()),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: navs.map((value) => value.tabPage).toList(growable: false),
        index: _index,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navs.map((value) => value.item).toList(growable: false),
        currentIndex: _index,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}

class NavigView {
  String _tabName;
  Icon _tabIcon;
  Color _tabBackground;
  Widget tabPage;
  BottomNavigationBarItem item;

  NavigView({String tabName, Icon tabIcon, Color tabBackground, Widget tabPage})
      : _tabName = tabName,
        _tabIcon = tabIcon,
        _tabBackground = tabBackground,
        tabPage = tabPage,
        item = BottomNavigationBarItem(
            title: Text(tabName),
            icon: tabIcon,
            backgroundColor: tabBackground);
}
