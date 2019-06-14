import 'dart:convert' show json;
import 'package:material_component/bean/CommonPageBean.dart';
import 'package:material_component/bean/GankListBean.dart';

import 'package:http/http.dart' as http;

class GankApi {
  static Future<GankListBean> getListData() async {
    final respnse = await http.get("http://gank.io/api/today");
    final jsonStr = json.decode(respnse.body);
    return GankListBean.fromJson(jsonStr);
  }

  static Future<CommonPageBean> getFuliPage(int index,
      {int pageNumbers = 10}) async {
    final respnse = await http
        .get('http://gank.io/api/data/%E7%A6%8F%E5%88%A9/$pageNumbers/$index');
    return CommonPageBean.fromJson(json.decode(respnse.body));
  }

  static Future<CommonPageBean> getCategoryData(String category, int index,
      {int pageNumbers = 20}) async {
    final respnse =
        await http.get('http://gank.io/api/data/$category/$pageNumbers/$index');
    return CommonPageBean.fromJson(json.decode(respnse.body));
  }

  static Future<CommonPageBean> search(String word, int index,
      {int resultNumber = 20, String category = 'all'}) async {
    final respnse = await http.get(
        'http://gank.io/api/search/query/$word/category/$category/count/$resultNumber/page/$index');
    return CommonPageBean.fromJson(json.decode(respnse.body));
  }
}
