
class Filter {
  late double lat;
  late double lon;
  late double z;
  late String cortarNo;
  late String cortarNm;
  late String rletTpCds;
  late String tradTpCds;

  Filter(String outerHtml) {
    final value = outerHtml.split("filter: {")[1].split("}")[0].trim().replaceAll("'","");
    lat = double.parse(value.split("lat:")[1].split(",")[0]);
    lon = double.parse(value.split("lon:")[1].split(",")[0]);
    z = double.parse(value.split("z:")[1].split(",")[0]);
    cortarNo = value.split("cortarNo:")[1].split(",")[0];
    cortarNm = value.split("cortarNm:")[1].split(",")[0];
    //print('Filter outerHtml : $outerHtml');
    cortarNo = '1168010600';
    rletTpCds = 'SG';
    tradTpCds = 'A1:B1:B2';
  }
}