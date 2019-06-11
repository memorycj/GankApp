import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

import 'CategoryWidget.dart';

const List<String> _allPages = <String>[
  'Android',
  'iOS',
  '前端',
  '休息视频',
  '拓展资源',
  '瞎推荐',
  'App'
];

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: _allPages.length, vsync: this);
  }


  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Category'),
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
          controller: _controller,
          tabs: _allPages
              .map((String page) => Tab(
                    text: page,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        children: _tabPage(),
        controller: _controller,
      ),
    );
  }

  List<Widget> _tabPage() {
    List<Widget> allPage = [];
    for (var pos = 0; pos < _allPages.length; pos++) {
      allPage.add(CategoryWidget(
        category: _allPages[pos],
      ));
    }
    return allPage;
  }
}
