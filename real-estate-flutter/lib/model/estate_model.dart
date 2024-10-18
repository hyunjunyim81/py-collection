import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/data/cluster.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/table/village.dart';

class EstateModel {
  Filter? filter;
  Cluster? cluster;
  List<Body> bodyList = [];

  List<Village> villageList = [];
  String selectedGu = '';
  String selectedDong = '';

  Village? findVillage(String gu) {
    try {
      return villageList.firstWhere((v) => v.gu == gu);
    }
    catch (e) {
      //print('not found Village');
    }
    return null;
  }
}