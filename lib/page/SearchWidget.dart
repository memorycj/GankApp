import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:material_component/bean/ItemData.dart';

import '../CommonComponent.dart';
import 'package:material_component/api/GankApi.dart';

class SearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchState();
  }
}

class SearchState extends State<SearchWidget> {
  TextEditingController _controller;
  ScrollController _listController;
  List<ItemData> _searchResults;
  bool isLoadMore = false;
  int _index = 1;
  String _searchTxt = '';

  @override
  void initState() {
    _controller = TextEditingController();
    _listController = ScrollController();
    _listController.addListener(() {
      if (_listController.position.pixels ==
          _listController.position.maxScrollExtent) {
        //滑到底部
        _loadMore();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'input search text'),
          onSubmitted: (value) {
            _submit(value);
          },
          controller: _controller,
        ),
        actions: <Widget>[
          InkWell(
            onTap: () {
              print('${_controller.value.text}');
              _submit(_controller.value.text);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: _searchResults == null
          ? Center(
        child: Text('Empty...'),
      )
          : ListView.builder(
        itemBuilder: _listItems,
        controller: _listController,
        itemCount: isLoadMore
            ? _searchResults.length + 1
            : _searchResults.length,
      ),
    );
  }

  void _submit(String text) {
    _searchTxt = text;
    _index = 1;
    GankApi.search(text, 1).then((value) {
      setState(() {
        _searchResults = value.results;
      });
    });
  }

  Widget _listItems(BuildContext context, int index) {
    return index < _searchResults.length ? _item(index) : _loadMoreItem();
  }

  void _loadMore() {
    setState(() {
      isLoadMore = true;
    });

    GankApi.search(_searchTxt, ++_index).then((value) {
      setState(() {
        isLoadMore = false;
        _searchResults.addAll(value.results);
      });
    });
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
    final data = _searchResults[index];

    return InkWell(
      onTap: () =>
      {
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
}
