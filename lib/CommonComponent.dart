import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  WebViewController webViewController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    contexts = context;
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: WebView(
        onWebViewCreated: (control){
          webViewController = control;
        },
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    ), onWillPop: (){
      if(webViewController==null){
        //返回到上个界面
        Navigator.pop(contexts);
        return;
      }
      //拦截back键
      webViewController.canGoBack().then((vale){
          if(vale){
            webViewController.goBack();
          }else{
            Navigator.pop(contexts);
          }
      });

    });
  }
}
