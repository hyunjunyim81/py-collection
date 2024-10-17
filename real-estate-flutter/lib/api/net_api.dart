import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/data/cluster.dart';

import 'package:real_estate/api/data/filter.dart';

class NetAPI {
  static const Map<String, String> defaultHeaders = {
    "User-Agent":"Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36"
  };

  static Future<Filter> searchResult(String gu, String dong) async {
    var uri = Uri.https('m.land.naver.com', '/search/result/${gu} ${dong}');
    http.Response response = await http.get(uri, headers: defaultHeaders);
    //print(response.body);
    final document = htmlParser.parse(response.body);
    final scripts = document.querySelectorAll('script');

    for (var script in scripts) {
      if (script.outerHtml.contains('filter:')) {
        return Filter(script.outerHtml);
      }
    }
    throw Exception("not found filter");
  }

  static Future<Cluster> cluster(Filter filter) async {
    var uri = Uri.parse(
        'https://m.land.naver.com/cluster/clusterList?view=atcl&cortarNo=1168010600&rletTpCd=SG%3ASMS&tradTpCd=A1%3AB1&z=14&lat=37.49911&lon=127.065463&btm=37.4755795&lft=127.0500135&top=37.5226331&rgt=127.0809125&pCortarNo=14_1168010600&addon=COMPLEX&bAddon=COMPLEX&isOnlyIsale=false');
    http.Response response = await http.get(uri, headers: defaultHeaders);
    //print('clusterList statusCode : ${response.statusCode}');
    //print('clusterList body : ${response.body}');
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    return Cluster.fromJson(jsonData)
      ..data?.article?.forEach((item) {
        item.generateUrl(filter);
      });
  }

  static Future<List<Body>> article(List<ARTICLE> articles) async {
    List<Body> bodyList = [];
    for (var article in articles) {
      for (var url in article.urls) {
        var uri = Uri.parse(url);
        http.Response response = await http.get(uri, headers: defaultHeaders);
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        var articleResponse = ArticleResponse.fromJson(jsonData);
        bodyList.addAll(articleResponse.body ?? []);
        await Future.delayed(const Duration(seconds: 1));
        //print('article url : $url, ${response.body}');
      }
    }
    print('article bodyList : ${bodyList.length}');
    return bodyList;
  }
}