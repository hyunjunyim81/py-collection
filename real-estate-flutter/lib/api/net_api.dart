import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/data/cluster.dart';

import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/net_header.dart';
import 'package:real_estate/api/table/search_option.dart';

import 'table/excel_reader.dart';

class NetAPI {

  static Future<Filter> searchResult(SearchOption option) async {
    //https://m.land.naver.com/search/result/강남구 대치동
    var uri = Uri.https('m.land.naver.com', '/search/result/${option.gu} ${option.dong}');
    http.Response response = await http.get(uri, headers: NetHeader.defaultHeaders);
    //print(response.body);
    final document = htmlParser.parse(response.body);
    final scripts = document.querySelectorAll('script');

    for (var script in scripts) {
      if (script.outerHtml.contains('filter:')) {
        var filter = Filter(script.outerHtml)..config(option);
        await ExcelReader.matched(filter);
        return filter;
      }
    }
    throw Exception("not found filter");
  }

  static Future<Cluster> cluster(Filter filter) async {
    var uri = Uri.parse('https://m.land.naver.com/cluster/clusterList?view=atcl'
        '&cortarNo=${filter.cortarNo}&rletTpCd=${filter.rletTpCds}'
        '&tradTpCd=${filter.tradTpCds}&z=${filter.z.toInt()}&lat=${filter.lat}'
        '&lon=${filter.lon}&btm=${filter.btm}&lft=${filter.lft}'
        '&top=${filter.top}&rgt=${filter.rgt}&pCortarNo='
        '&addon=COMPLEX&bAddon=COMPLEX&isOnlyIsale=false');
    http.Response response = await http.get(uri, headers: NetHeader.randomHeader());
    print('clusterList uri : ${uri}');
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
        try {
          var uri = Uri.parse(url);
          http.Response response = await http.get(uri, headers: NetHeader.randomHeader());
          Map<String, dynamic> jsonData = jsonDecode(response.body);
          var articleResponse = ArticleResponse.fromJson(jsonData);
          if (articleResponse.body?.isNotEmpty ?? false) {
            bodyList.addAll(articleResponse.body!);
          }
          await Future.delayed(NetHeader.randomDuration());
          print('article url : $url , ${articleResponse.body?.length}');
          //break;
        }
        catch(e) {
          print('article error url : $url');
        }
      }
      //break;
    }
    print('article bodyList : ${bodyList.length}');
    return bodyList;
  }
}