import 'package:real_estate/api/table/search_option.dart';

class Filter {
  late double lat;
  late double lon;
  late double z;
  late String cortarNo;
  late String cortarNm;
  late String rletTpCds;
  late String tradTpCds;

  double btm = 0;
  double lft = 0;
  double top = 0;
  double rgt = 0;

  String gu = '';
  String dong = '';

  Filter(String outerHtml) {
    final value = outerHtml.split("filter: {")[1].split("}")[0].trim().replaceAll("'","");
    lat = double.parse(value.split("lat:")[1].split(",")[0]);
    lon = double.parse(value.split("lon:")[1].split(",")[0]);
    z = double.parse(value.split("z:")[1].split(",")[0]);
    cortarNo = value.split("cortarNo:")[1].split(",")[0];
    cortarNm = value.split("cortarNm:")[1].split(",")[0];
    //print('Filter outerHtml : $outerHtml');
    //rletTpCds = 'SG%3ASMS';
    //tradTpCds = 'A1%3AB1%3AB2';
  }

  void config(SearchOption option) {
    rletTpCds = option.rletTpCd();
    tradTpCds = option.tradTpCd();
    gu = option.gu;
    dong = option.dong;
  }

  void matched(Map<String, String> entry) {
    btm = double.parse(entry['btm'] ?? '0');
    lft = double.parse(entry['lft'] ?? '0');
    top = double.parse(entry['top'] ?? '0');
    rgt = double.parse(entry['rgt'] ?? '0');
  }
}