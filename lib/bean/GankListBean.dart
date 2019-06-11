import 'ItemData.dart';
class GankListBean {
  List<dynamic> categorys;
  final bool error;
  Result result;

  GankListBean({this.error, this.categorys, this.result});

  factory GankListBean.fromJson(Map<String, dynamic> json) {
    var jsondata = GankListBean(
        error: json["error"],
        categorys: json["category"],
        result: Result.fromJson(json["results"]));
//    print(jsondata);
    return jsondata;
  }

  @override
  String toString() {
    return 'GankListBean{categorys: $categorys, error: $error, result: $result}';
  }
}

class Result {
  List<ItemData> androids;
  List<ItemData> apps;
  List<ItemData> ios;
  List<ItemData> sleepVideos;
  List<ItemData> h5;
  List<ItemData> expandSources;
  List<ItemData> xiaRecommend;
  List<ItemData> fulis;

  Result();

  factory Result.fromJson(Map<String, dynamic> json) {
    final results = Result();
    if (json['Android'] != null) {
      results.androids = [];
      for (var android in json['Android']) {
        results.androids.add(ItemData.fromJson(android));
      }
    }

    if (json['App'] != null) {
      results.apps = [];
      for (var app in json['App']) {
        results.apps.add(ItemData.fromJson(app));
      }
    }

    if (json['iOS'] != null) {
      results.ios = [];
      for (var ios in json['iOS']) {
        results.ios.add(ItemData.fromJson(ios));
      }
    }

    if (json['休息视频'] != null) {
      results.sleepVideos = [];
      for (var video in json['休息视频']) {
        results.sleepVideos.add(ItemData.fromJson(video));
      }
    }

    if (json['前端'] != null) {
      results.h5 = [];
      for (var h5 in json['前端']) {
        results.h5.add(ItemData.fromJson(h5));
      }
    }
    if (json['拓展资源'] != null) {
      results.expandSources = [];
      for (var expand in json['拓展资源']) {
        results.expandSources.add(ItemData.fromJson(expand));
      }
    }
    if (json['瞎推荐'] != null) {
      results.xiaRecommend = [];
      for (var xia in json['瞎推荐']) {
        results.xiaRecommend.add(ItemData.fromJson(xia));
      }
    }

    if (json['福利'] != null) {
      results.fulis = [];
      for (var fuli in json['福利']) {
        results.fulis.add(ItemData.fromJson(fuli));
      }
    }
    return results;
  }

  @override
  String toString() {
    return 'Result{androids: $androids, apps: $apps, ios: $ios, sleepVideos: $sleepVideos, h5: $h5, expandSources: $expandSources, xiaRecommend: $xiaRecommend, fulis: $fulis}';
  }
}

