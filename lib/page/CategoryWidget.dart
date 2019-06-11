import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_component/bean/ItemData.dart';

import '../CommonComponent.dart';
import 'GankApi.dart';

class CategoryWidget extends StatefulWidget {
  final String category;

  CategoryWidget({Key key, this.category})
      : assert(category != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryWidgetState();
  }
}

class CategoryWidgetState extends State<CategoryWidget> with AutomaticKeepAliveClientMixin{
  List<ItemData> _categoryData;
  static const int _default_index = 1;
  int _index = 1;
  ScrollController _controller;
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _pullNetData();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        //滑到底部
        _loadMore();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _categoryData == null
        ? LoadingWidget()
        : ListView.builder(
            controller: _controller,
            itemCount:
                _isLoadMore ? _categoryData.length + 1 : _categoryData.length,
            itemBuilder: _listItems,
          );
  }

  _pullNetData() {
    _index = _default_index;
    GankApi.getCategoryData(widget.category, _default_index).then((value) {
      if (mounted)
        setState(() {
          _categoryData = value.results;
        });
    });
  }

  _loadMore() {
    if (mounted)
      setState(() {
        _isLoadMore = true;
      });
    GankApi.getCategoryData(widget.category, ++_index).then((value) {
      if (mounted)
        setState(() {
          _isLoadMore = false;
          if (_categoryData == null) _categoryData = [];
          _categoryData.addAll(value.results);
        });
    });
  }

  Widget _listItems(BuildContext context, int index) {
    return index < _categoryData.length ? _item(index) : _loadMoreItem();
  }

  Widget _loadMoreItem() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }

  Widget _item(int index) {
    final data = _categoryData[index];

    return GestureDetector(
      onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new WebPage(
                url: data.url,
                title: data.desc,
              );
            }))
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
                        width: 90,
                        height: 90,
                        imageUrl: data.images[0],
                        placeholder: (context, url) {
                          return Image(
                            image: AssetImage("images/fuli.png"),
                            fit: BoxFit.cover,
                            width: 90.0,
                            height: 90.0,
                          );
                        },
                      )
              ],
            )),
        elevation: 3.0,
        margin: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
