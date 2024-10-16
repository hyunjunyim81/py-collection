import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as htmlParser;

class NaverAPI {

  void searchResult(String gu, String dong) async {
    var url = Uri.https('m.land.naver.com', '/search/result/${gu} ${dong}');
    http.Response response = await http.get(url);
    print(response.body);
    final document = htmlParser.parse(response.body);
    final scripts = document.querySelectorAll('script');
    print(scripts.length);

    scripts.forEach((script) {
      if (script.outerHtml.contains('filter:')) {
        final _value = script.outerHtml.split("filter: {")[1].split("}")[0].trim().replaceAll("'","");//.replace("'","");
        final _lat = _value.split("lat:")[1].split(",")[0];
        final _lon = _value.split("lon:")[1].split(",")[0];
        final _z = _value.split("z:")[1].split(",")[0];
        final _cortarNo = _value.split("cortarNo:")[1].split(",")[0];
        final _cortarNm = _value.split("cortarNm:")[1].split(",")[0];
        print(script.outerHtml);
      }
    });
  }
}