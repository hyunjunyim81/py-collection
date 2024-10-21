import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/data/cluster.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/net_api.dart';
import 'package:real_estate/api/table/search_option.dart';
import 'package:real_estate/api/table/village.dart';
import 'package:real_estate/model/filter_model.dart';

class EstateModel {
  Filter? filter;
  Cluster? cluster;

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

  Future<void> requestEstate(FilterModel filterModel) async {
    filter = await NetAPI.searchResult(SearchOption.basic(
      selectedGu: selectedGu,
      selectedDong: selectedDong,
    ));
    print('requestEstate() filter : ${filter!.lat} / ${filter!.lon}');
    cluster = await NetAPI.cluster(filter!);
    print('requestEstate() cluster : ${cluster!.data?.totalCount()}');
    filterModel.reset();
    int cnt = await NetAPI.article(cluster?.data?.article ?? [],
        (bodies)  {
          filterModel.config(bodies);
        });

    print('requestEstate() article : ${cnt}');
  }
}