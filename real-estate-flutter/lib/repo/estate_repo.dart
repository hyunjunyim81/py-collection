import 'package:real_estate/api/data/cluster.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/net_api.dart';
import 'package:real_estate/api/table/search_option.dart';
import 'package:real_estate/api/table/village.dart';
import 'filter_repo.dart';

class EstateRepo {
  Filter? filter;
  Cluster? cluster;

  List<Village> villageList = [];
  String selectedGu = '';
  String selectedDong = '';
  List<OnStatus> _onStatusList = [];

  Village? findVillage(String gu) {
    try {
      return villageList.firstWhere((v) => v.gu == gu);
    }
    catch (e) {
      //print('not found Village');
    }
    return null;
  }

  SearchOption getOption() {
    return SearchOption.basic(
      selectedGu: selectedGu,
      selectedDong: selectedDong,
    );
  }

  void addOnStatus(OnStatus s){
    _onStatusList.add(s);
  }

  void removeOnStatus(OnStatus s) {
    _onStatusList.remove(s);
  }

  void _notifyOnStatus(int step, int totalStep) {
    for (var s in _onStatusList) {
      s(step, totalStep);
    }
  }

  void requestEstate(FilterRepo filterModel) async {
    // filter = await NetAPI.searchResult(getOption());
    // print('requestEstate() filter : ${filter!.lat} / ${filter!.lon}');
    // cluster = await NetAPI.cluster(filter!);
    // print('requestEstate() cluster : ${cluster!.data!.totalCount()}');
    // filterModel.reset();
    // int cnt = await NetAPI.article(cluster!.data!,
    //     (bodies)  {
    //       filterModel.config(bodies);
    //     },
    //     (step, totalStep) {
    //       _notifyOnStatus(step, totalStep);
    //       print('requestEstate() step : $step / $totalStep');
    //     });
    //
    // print('requestEstate() article : ${cnt}');
  }
}