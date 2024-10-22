import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/table/role_type.dart';

import 'thing.dart';

class DownTown extends Thing
{
  DownTown.config(Body body) {
    setting(body);
  }

  DownTown.dummy()
  {
    atclNo = "2450976476";
    atclNm = '대형상가';
    rletTpNm = '상기';
    tradTpCd = 'B2';
    tradTpNm = '월세';
    flrInfo = '4/17';

    prc = 27000;
    rentPrc = 1687;

    atclCfmYmd = '24.10.18.';

    spc1 = double.tryParse("394") ?? 0;
    spc2 = double.tryParse("290.91") ?? 0;

    lat = 37.507209;
    lng = 127.056056;

    atclFetrDesc = '포스코사거리 코너 접근성 최고 입지 우수한 인테리어';

    tagList.clear();
    tagList.addAll(['10년이내', '지상층(1층제외)', '주차가능']);

    cpid = 'gongsilclub';
    cpNm = '공실클럽';
    cpCnt = 1;
    rltrNm = '(주)원앤원부동산중개법인';
  }

  @override
  String rletTpCd() {
    return SG_code;
  }
}