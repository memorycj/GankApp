import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_component/bean/ItemData.dart';
import '../CommonComponent.dart';
import 'BannerWidget.dart';
import 'GankApi.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  List<ItemData> _data = [];

  @override
  void initState() {
    super.initState();
    _pullHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Newest"),
          centerTitle: true,
        ),
        body: _data.length <= 0
            ? LoadingWidget()
            : ListView(
                children: _getListViewItems(),
              ));
  }

  void _pullHomeData() {
    GankApi.getListData().then((value) {
      setState(() {
        _data.addAll(value.result.androids);
        _data.addAll(value.result.apps);
        _data.addAll(value.result.ios);
        _data.addAll(value.result.fulis);
        _data.addAll(value.result.expandSources);
        _data.addAll(value.result.h5);
        _data.addAll(value.result.sleepVideos);
      });
    });
  }

  List<Widget> _getListViewItems() {
    var widget = List<Widget>();
    List<ItemData> fuliUrls = [];
    for (var i = 0; i < _data.length; i++) {
      var data = _data[i];
      if (data.type == '福利') {
        fuliUrls.add(data);
        continue;
      }
      widget.add(GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return WebPage(
              url: data.url,
              title: data.desc,
            );
          }));
        },
        child: new Card(
          child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      data.desc,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  data.images == null || data.images.isEmpty
                      ? Text('')
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: data.images[0],
                          width: 90.0,
                          height: 90.0,
                          placeholder: (context, url) {
                            return Image(
                              image: AssetImage("images/fuli.png"),
                              width: 90.0,
                              height: 90.0,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                ],
              )),
          elevation: 3.0,
          margin: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
        ),
      ));
    }
    if (fuliUrls.isNotEmpty) widget.insert(0, BannerWidget(fuliUrls));
    return widget;
  }
}
