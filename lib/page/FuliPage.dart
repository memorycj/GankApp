import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_component/bean/ItemData.dart';

import '../CommonComponent.dart';
import 'GankApi.dart';

class FuliPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FuliState();
  }
}

class FuliState extends State<FuliPage> {
  ScrollController _scrollController = ScrollController();
  int _index = 1;
  static const _default_index = 1;
  List<ItemData> _fuliPages = [];
  bool _isLoadMore = false;

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshFuliPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //滚到底部
        ++_index;
        _loadMoreFuliPage();
      }
    });
  }

  _refreshFuliPage() {
    GankApi.getFuliPage(_default_index).then((value) {
      setState(() {
        _fuliPages = value.results;
      });
    });
  }

  _loadMoreFuliPage() {
    setState(() {
      //刷新loadMore状态
      _isLoadMore = true;
    });
    print("start loadMore");
    GankApi.getFuliPage(_index).then((value) {
      print("end loadMore");
      setState(() {
        _isLoadMore = false;
        _fuliPages.addAll(value.results);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MeiZi'),
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.all(10),
          child: _fuliPages.length == 0
              ? LoadingWidget()
              : GridView.builder(
                  controller: _scrollController,
                  itemCount:
                      _isLoadMore ? _fuliPages.length + 1 : _fuliPages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0),
                  itemBuilder: _getWidget),
        ));
  }

  Widget _getWidget(BuildContext context, int index) {
    if (index < _fuliPages.length) {
      return _PhotoWidget(
        photoInfo: _fuliPages[index],
      );
    }
    return _getMoreWidget();
  }

  Widget _getMoreWidget() {
    print("loadMore widget");
    return Center(
        child: Column(
      children: <Widget>[
        CircularProgressIndicator(
          strokeWidth: 2.0,
        ),
        Text('load more')
      ],
    ));
  }
}

class _PhotoWidget extends StatelessWidget {
  final ItemData photoInfo;

  _PhotoWidget({Key key, this.photoInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showPhoto(context);
      },
      child: Container(
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: photoInfo.url,
          placeholder: (context, url) {
            return Image(
              image: AssetImage("images/fuli.png"),
              fit: BoxFit.cover,
              width: 90.0,
              height: 90.0,
            );
          },
        ),
      ),
    );
  }

  _showPhoto(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
      return ImagePreviewWidget(photoInfo);
    }));
  }
}
