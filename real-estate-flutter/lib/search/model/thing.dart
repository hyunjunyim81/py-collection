import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/common/util/num_util.dart';

abstract class Thing
{
  late String atclNo; //"2451136972",
  late String atclNm; //"대형사무실",
  late String rletTpNm; //"사무실",
  late String tradTpCd; //"B2",
  late String tradTpNm; //"월세",
  late String flrInfo; //"4/17",

  late int prc; //27000,
  late int rentPrc; //1687,

  late String atclCfmYmd; //"24.10.18.",

  late double spc1; //"364",
  late double spc2; //"290.91",

  late double lat; //37.507209,
  late double lng; //127.056056,

  late String atclFetrDesc; //"포스코사거리 코너 접근성 최고 입지 우수한 인테리어",
  List<String> tagList = []; //"10년이내", "지상층(1층제외)", "주차가능"

  late String cpid; //"gongsilclub",
  late String cpNm; //"공실클럽",
  late int cpCnt; //1,
  late String rltrNm; //"(주)블루핀부동산중개법인",


  void setting(Body other)
  {
    atclNo = other.atclNo ?? '';
    atclNm = other.atclNm ?? '';
    rletTpNm = other.rletTpNm ?? '';
    tradTpCd = other.tradTpCd ?? '';
    tradTpNm = other.tradTpNm ?? '';
    flrInfo = other.flrInfo ?? '';

    prc = other.prc ?? 0;
    rentPrc = other.rentPrc ?? 0;

    atclCfmYmd = other.atclCfmYmd ?? '-.';

    spc1 = double.tryParse(other.spc1 ?? '0') ?? 0;
    spc2 = double.tryParse(other.spc2 ?? '0') ?? 0;

    lat = other.lat ?? 0;
    lng = other.lng ?? 0;

    atclFetrDesc = other.atclFetrDesc ?? '';
    tagList.clear();
    tagList.addAll(other.tagList ?? []);

    cpid = other.cpid ?? '';
    cpNm = other.cpNm ?? '';
    cpCnt = other.cpCnt ?? 1;
    rltrNm = other.rltrNm ?? '';
  }

  String priceDesc() {
    return tradTpCd == 'A1'
        ? '$tradTpNm ${priceUnit()}'
        : '$tradTpNm ${priceUnit()} / ${rentPriceUnit()}';
  }

  String priceUnit() {
    return _price(prc);
  }

  String rentPriceUnit() {
    return _price(rentPrc);
  }

  String tags() {
    return tagList.toString().replaceAll('[', '').replaceAll(']', '');
  }

  String rletTpCd();

  String spaceSquare() {
    return '${spc1.toStringAsDynamic(2)}/${spc2.toStringAsDynamic(2)}㎡';
  }

  String spaceKor() {
    return '${(spc1*0.3025).toStringAsDynamic(2)}/${(spc2*0.3025).toStringAsDynamic(2)}평';
  }

  String _price(int price) {
    int first = price~/10000;
    int second = (price%10000).toInt();
    if (first > 0) {
      return second == 0
          ? '${price~/10000}억'
          : '${price~/10000}억 ${(price%10000).toInt()}만';
    }
    else {
      return '$second만';
    }
  }
}