import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bean/ItemData.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      height: window.physicalSize.height,
      child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
              new Container(
                  padding: EdgeInsets.only(top: 10.0), child: new Text("正在加载")),
            ],
          )),
    );
  }
}

class ImagePreviewWidget extends StatelessWidget {
  final ItemData photoInfo;

  ImagePreviewWidget(this.photoInfo, {Key key}) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(photoInfo.desc),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
              tag: photoInfo.url,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: photoInfo.url,
                placeholder: (context, url) {
                  return Image(
                    image: AssetImage("images/fuli.png"),
                    fit: BoxFit.cover,
                  );
                },
              )),
        ),
      ),
    );
  }
}

class WebPage extends StatefulWidget {
  WebPage({Key key, this.url, this.title}) : super(key: key);

  final String url;
  final String title;

  @override
  State<StatefulWidget> createState() {
    return new WebPageState();
  }
}

class WebPageState extends State<WebPage> {
  var contexts;
  var isHideLoading = false;
  WebViewController webViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              WebView(
                onWebViewCreated: (control) {
                  webViewController = control;
                },
                onPageFinished: (url) {
                  isHideLoading = url == widget.url;
                  //刷新
                  setState(() {});
                },
                initialUrl: widget.url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
              Offstage(
                offstage: isHideLoading,
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3.0,
                    ),
                  ),
                  constraints: BoxConstraints(
                      minWidth: double.infinity, minHeight: double.infinity),
                ),
              )
            ],
          ),
        ),
        onWillPop: () {
          if (webViewController == null) {
            //返回到上个界面
            Navigator.pop(contexts);
            return;
          }
          //拦截back键
          webViewController.canGoBack().then((vale) {
            if (vale) {
              webViewController.goBack();
            } else {
              Navigator.pop(contexts);
            }
          });
        });
  }
}
