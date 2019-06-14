import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_component/bean/ItemData.dart';

class BannerWidget extends StatefulWidget {
  final List<ItemData> bannerUrls;
  final OnTapBannerItem onTap;

  BannerWidget(this.bannerUrls, {Key key, this.onTap})
      : assert(bannerUrls != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BannerState();
  }
}

class BannerState extends State<BannerWidget> {
  PageController _pageController;
  Timer timer;
  int _realIndex = 1;
  int _virtualIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _realIndex);
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // 自动滚动
      /// print(realIndex);
      _pageController.animateToPage(_realIndex + 1,
          duration: Duration(milliseconds: 300), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: _pageChange,
            controller: _pageController,
            children: _buildItems(),
          ),
          _buildIndicator()
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    final List<Widget> items = [];
    if (widget.bannerUrls.length > 0) {
      //添加尾部到第一个
      items.add(_buildItem(widget.bannerUrls[widget.bannerUrls.length - 1]));
      items.addAll(widget.bannerUrls
          .map((itemData) => _buildItem(itemData))
          .toList(growable: false)); //growable 固定的list长度，省内存
      //添加第一个到尾部
      items.add(_buildItem(widget.bannerUrls[0]));
    }
    return items;
  }

  Widget _buildItem(ItemData bannerUrl) {
    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) widget.onTap(bannerUrl);
      },
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: bannerUrl.url,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  void _pageChange(int index) {
    _realIndex = index;
    int count = widget.bannerUrls.length;
    if (index == 0) {
      _virtualIndex = count - 1;
      _pageController.jumpToPage(count);
    } else if (index == count + 1) {
      _virtualIndex = 0;
      _pageController.jumpToPage(1);
    } else {
      _virtualIndex = index - 1;
    }
    setState(() {});
  }

  Widget _buildIndicator() {
    final length = widget.bannerUrls.length;
    List<Widget> indicators = [];
    for (var i = 0; i < length; i++) {
      indicators.add(Container(
        width: 6.0,
        height: 6.0,
        margin: EdgeInsets.symmetric(horizontal: 1.5, vertical: 10.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == _virtualIndex ? Colors.white : Colors.grey),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: indicators,
    );
  }
}

typedef OnTapBannerItem(ItemData itemData);
