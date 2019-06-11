import 'ItemData.dart';

class CommonPageBean {
  bool error;
  List<ItemData> results;

  CommonPageBean({this.error, this.results});

  factory CommonPageBean.fromJson(Map<String, dynamic> jsonMap) {
    if (jsonMap == null || jsonMap.isEmpty) return null;
    var pageBean = CommonPageBean();
    if (jsonMap.containsKey('error')) pageBean.error = jsonMap['error'];
    if (jsonMap.containsKey('results')) {
      pageBean.results = [];
      for (var item in jsonMap['results']) {
        pageBean.results.add(ItemData.fromJson(item));
      }
    }
    return pageBean;
  }
}
