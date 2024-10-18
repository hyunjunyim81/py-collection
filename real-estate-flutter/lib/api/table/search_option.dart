import 'trade_type.dart';
import 'role_type.dart';

class SearchOption {
  static const String colon = '%3A';
  late String gu;
  late String dong;
  late List<RoleType> rletTpCdList;
  late List<TradeType> tradTpCdList;

  SearchOption({required this.gu,
    required this.dong,
    required this.rletTpCdList,
    required this.tradTpCdList});


  String rletTpCd() {
    String ret = '';
    for (var type in rletTpCdList) {
      if (ret.isEmpty) {
        ret += type.key;
      }
      else {
        ret += colon + type.key;
      }
    }
    return ret.isEmpty ? RoleType.SG.key : ret;
  }

  String tradTpCd() {
    String ret = '';
    for (var type in tradTpCdList) {
      if (ret.isEmpty) {
        ret += type.key;
      }
      else {
        ret += colon + type.key;
      }
    }
    return ret.isEmpty ? TradeType.A1.key : ret;
  }

  SearchOption.basic({String selectedGu = '강남구',
    String selectedDong = '개포동'}) {
    gu = selectedGu;
    dong = selectedDong;
    rletTpCdList = [RoleType.SG, RoleType.SMS];
    tradTpCdList = [TradeType.A1, TradeType.B2, TradeType.B3];
  }
}