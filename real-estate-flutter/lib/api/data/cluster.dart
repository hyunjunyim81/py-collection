import 'package:real_estate/api/data/filter.dart';

class Cluster {
  String? code;
  Data? data;
  int? z;
  Cortar? cortar;
  int? nOEXPSCNT;

  Cluster({this.code, this.data, this.z, this.cortar, this.nOEXPSCNT});

  Cluster.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    z = json['z'];
    cortar = json['cortar'] != null ? Cortar.fromJson(json['cortar']) : null;
    nOEXPSCNT = json['NOEXPSCNT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['code'] = code;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['z'] = z;
    if (cortar != null) {
      data['cortar'] = cortar?.toJson();
    }
    data['NOEXPSCNT'] = nOEXPSCNT;
    return data;
  }
}

class Data {
  List<ARTICLE>? article;

  Data({this.article});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['ARTICLE'] != null) {
      article = <ARTICLE>[];
      json['ARTICLE'].forEach((v) {
        article?.add(ARTICLE.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (article != null) {
      data['ARTICLE'] = article!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  int totalCount() {
    int tc = 0;
    for (ARTICLE a in article ?? []) {
      tc += a.count ?? 0;
    }
    return tc;
  }
}

class ARTICLE {
  String? lgeo;
  int? count;
  int? z;
  double? lat;
  double? lon;
  double? psr;
  bool? tourExist;
  int len_pages = 1;
  List<String> urls = [];

  ARTICLE(
      {this.lgeo,
        this.count,
        this.z,
        this.lat,
        this.lon,
        this.psr,
        this.tourExist});

  void generateUrl(Filter filter) {
    len_pages = ((count ?? 0) / 20).ceil();
    print('generateUrl ${filter.cortarNo}/$lgeo count : $count, page : $len_pages');
    urls.clear();
    for (var idx = 1; idx <= len_pages; ++idx) {
      urls.add('https://m.land.naver.com/cluster/ajax/articleList?itemId=${lgeo}'
          '&mapKey=&lgeo=${lgeo}&showR0=&rletTpCd=${filter.rletTpCds}'
          '&tradTpCd=${filter.tradTpCds}&z=${z ?? 0}&lat=${lat}&lon=${lon}'
          '&totCnt=${count}&page=${idx}');
      //print('generateUrl url : ${urls.last}');
    }
  }

  ARTICLE.fromJson(Map<String, dynamic> json) {
    lgeo = json['lgeo'];
    count = json['count'];
    z = json['z'];
    lat = json['lat'];
    lon = json['lon'];
    psr = json['psr'];
    tourExist = json['tourExist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['lgeo'] = lgeo;
    data['count'] = count;
    data['z'] = z;
    data['lat'] = lat;
    data['lon'] = lon;
    data['psr'] = psr;
    data['tourExist'] = tourExist;
    return data;
  }
}

class Cortar {
  Detail? detail;
  String? dvsnLat;
  String? dvsnLon;

  Cortar({this.detail, this.dvsnLat, this.dvsnLon});

  Cortar.fromJson(Map<String, dynamic> json) {
    detail =
    json['detail'] != null ? Detail.fromJson(json['detail']) : null;
    dvsnLat = json['dvsnLat'];
    dvsnLon = json['dvsnLon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (detail != null) {
      data['detail'] = detail?.toJson();
    }
    data['dvsnLat'] = dvsnLat;
    data['dvsnLon'] = dvsnLon;
    return data;
  }
}

class Detail {
  String? cortarNo;
  String? cortarNm;
  String? cortarType;
  String? cityLngNm;
  String? cityNm;
  String? dvsnNm;
  String? secNm;
  String? mapXCrdn;
  String? mapYCrdn;
  String? cityNo;
  String? dvsnNo;
  String? secNo;
  String? regionName;

  Detail(
      {this.cortarNo,
        this.cortarNm,
        this.cortarType,
        this.cityLngNm,
        this.cityNm,
        this.dvsnNm,
        this.secNm,
        this.mapXCrdn,
        this.mapYCrdn,
        this.cityNo,
        this.dvsnNo,
        this.secNo,
        this.regionName});

  Detail.fromJson(Map<String, dynamic> json) {
    cortarNo = json['cortarNo'];
    cortarNm = json['cortarNm'];
    cortarType = json['cortarType'];
    cityLngNm = json['cityLngNm'];
    cityNm = json['cityNm'];
    dvsnNm = json['dvsnNm'];
    secNm = json['secNm'];
    mapXCrdn = json['mapXCrdn'];
    mapYCrdn = json['mapYCrdn'];
    cityNo = json['cityNo'];
    dvsnNo = json['dvsnNo'];
    secNo = json['secNo'];
    regionName = json['regionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['cortarNo'] = cortarNo;
    data['cortarNm'] = cortarNm;
    data['cortarType'] = cortarType;
    data['cityLngNm'] = cityLngNm;
    data['cityNm'] = cityNm;
    data['dvsnNm'] = dvsnNm;
    data['secNm'] = secNm;
    data['mapXCrdn'] = mapXCrdn;
    data['mapYCrdn'] = mapYCrdn;
    data['cityNo'] = cityNo;
    data['dvsnNo'] = dvsnNo;
    data['secNo'] = secNo;
    data['regionName'] = regionName;
    return data;
  }
}