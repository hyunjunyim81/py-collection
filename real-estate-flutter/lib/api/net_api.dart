import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;
import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/data/cluster.dart';

import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/net_cache.dart';
import 'package:real_estate/api/net_header.dart';
import 'package:real_estate/api/table/search_option.dart';
import 'package:real_estate/search/model/thing.dart';
import 'package:url_launcher/url_launcher.dart';

import 'table/excel_reader.dart';

typedef OnArticle = void Function(List<Body>);
typedef OnStatus = void Function(int, int);

class NetAPI {

  static Future<Filter> searchResult(SearchOption option) async {
    //https://m.land.naver.com/search/result/강남구 대치동
    String body = await NetCache.read(CacheType.search, '${option.gu} ${option.dong}');
    var usedCache = body.isNotEmpty;
    if (!usedCache) {
      var uri = Uri.https('m.land.naver.com', '/search/result/${option.gu} ${option.dong}');
      http.Response response = await http.get(uri, headers: await NetHeader.randomHeader());
      body = response.body;
      //print(response.body);
      await NetCache.write(body, CacheType.search, '${option.gu} ${option.dong}');
    } else {
      print('read search cache ${option.gu} ${option.dong}');
    }

    final document = htmlParser.parse(body);
    final scripts = document.querySelectorAll('script');

    for (var script in scripts) {
      if (script.outerHtml.contains('filter:')) {
        var filter = Filter(script.outerHtml)..config(option);
        await ExcelReader.matched(filter);
        await Future.delayed(NetHeader.randomDuration(usedCache));
        return filter;
      }
    }
    await Future.delayed(NetHeader.randomDuration(usedCache));
    throw Exception("not found filter");
  }

  static Future<Cluster> cluster(Filter filter) async {
    String body = await NetCache.read(CacheType.cluster, filter.cortarNo);
    var usedCache = body.isNotEmpty;
    if (!usedCache) {
      var uri = Uri.parse('https://m.land.naver.com/cluster/clusterList?view=atcl'
          '&cortarNo=${filter.cortarNo}&rletTpCd=${filter.rletTpCds}'
          '&tradTpCd=${filter.tradTpCds}&z=${filter.z.toInt()}&lat=${filter.lat}'
          '&lon=${filter.lon}&btm=${filter.btm}&lft=${filter.lft}'
          '&top=${filter.top}&rgt=${filter.rgt}&pCortarNo='
          '&addon=COMPLEX&bAddon=COMPLEX&isOnlyIsale=false');
      http.Response response = await http.get(uri, headers: await NetHeader.randomHeader());
      body = response.body;
      //print(response.body);
      await NetCache.write(body, CacheType.cluster, filter.cortarNo);
      print('clusterList ${filter.cortarNo} uri : ${uri}');
    } else {
      print('read cluster cache (${filter.cortarNo})');
    }

    //print('clusterList statusCode : ${response.statusCode}');
    //print('clusterList body : ${response.body}');
    Map<String, dynamic> jsonData = jsonDecode(body);
    var cluster = Cluster.fromJson(jsonData)
      ..data?.article?.forEach((item) {
        item.generateUrl(filter);
      });
    await Future.delayed(NetHeader.randomDuration(usedCache));
    return cluster;
  }

  static Future<int> articlePage(ARTICLE article, String url, int page, OnArticle onArticle) async {
    var usedCache = false;
    int cnt = 0;
    try {
      String body = await NetCache.read(CacheType.article,
          article.lgeo ?? "empty",
          page: page, totalPageCnt: article.urls.length);
      usedCache = body.isNotEmpty;
      if (!usedCache) {
        var uri = Uri.parse(url);
        http.Response response = await http.get(uri, headers: await NetHeader.randomHeader());
        body = response.body;
        await NetCache.write(body, CacheType.article,
            article.lgeo ?? "empty",
            page: page, totalPageCnt: article.urls.length);
        print('article url : $url');
      }
      else {
        print('read article cache (${article.lgeo ?? "empty"} / ${page})');
      }

      Map<String, dynamic> jsonData = jsonDecode(body);
      var articleResponse = ArticleResponse.fromJson(jsonData);
      if (articleResponse.body?.isNotEmpty ?? false) {
        onArticle(articleResponse.body!);
        cnt = articleResponse.body!.length;
      }
      print('article body count : ${articleResponse.body?.length}');
    }
    catch(e) {
      print('article error url : $url');
      print('article error : $e');
    }
    await Future.delayed(NetHeader.randomDuration(usedCache));
    return cnt;
  }

  static Future<int> articleAll(Data data, OnArticle onArticle, OnStatus onStatus) async {
    int totalCnt = 0;
    int totalStep = data.totalStep();
    int step = 0;
    for (var article in data.article ?? []) {
      for (int i = 0; i < article.urls.length; ++i) {
        var url = article.urls[i];
        totalCnt += await articlePage(article, url, i + 1, onArticle);
        onStatus(++step, totalStep);
      }
    }
    onStatus(totalStep, totalStep);
    print('article totalCnt : $totalCnt');
    return totalCnt;
  }

  static Future<void> launchInBrowser(Filter filter, Thing thing) async {
    var url = Uri.parse('https://fin.land.naver.com/articles/${thing.atclNo}');
    print('launchInBrowser ${url.toString()}');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication,)) {
      throw Exception('Could not launch $url');
    }
  }
}