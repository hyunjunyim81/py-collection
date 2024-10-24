import 'package:real_estate/api/data/cluster.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/net_api.dart';
import 'package:real_estate/api/net_cache.dart';
import 'package:real_estate/api/skip_exception.dart';
import 'package:real_estate/api/table/search_option.dart';

class CollectionStep {
  final String gu;
  final String dong;
  Filter? filter;
  Cluster? cluster;

  CollectionStep({required this.gu, required this.dong});

  Future<bool> next() async {
    try {
      if (filter == null) {
        await _loadFilter();
        return false;
      }

      if (cluster == null) {
        await _loadCluster();
        return false;
      }

      await _loadArticle();
    }
    catch (e) {
      if (e is SkipException) {
        print('next() SkipException $gu/$dong');
        return true;
      }
      else {
        return false;
      }
    }
    return true;
  }

  void complete() {
    filter = null;
    cluster = null;
  }

  SearchOption getOption() {
    return SearchOption.basic(
      selectedGu: gu,
      selectedDong: dong,
    );
  }

  Future<void> _loadFilter() async {
    var option = getOption();
    if (await NetCache.checkFile(CacheType.search, '${option.gu} ${option.dong}') == CacheState.valid) {
      await Future.delayed(const Duration(seconds: 3));
      throw SkipException();
    }
    filter = await NetAPI.searchResult(getOption());
    print('_loadFilter() filter : ${filter!.lat} / ${filter!.lon}');
  }

  Future<void> _loadCluster() async {
    if (await NetCache.checkFile(CacheType.search, filter!.cortarNo) == CacheState.valid) {
      await Future.delayed(const Duration(seconds: 3));
      throw SkipException();
    }
    cluster = await NetAPI.cluster(filter!);
    print('_loadCluster() cluster : ${cluster!.data!.totalCount()}');
  }

  Future<void> _loadArticle() async {
    // filter = await NetAPI.searchResult(getOption());
    // print('requestEstate() filter : ${filter!.lat} / ${filter!.lon}');
    // cluster = await NetAPI.cluster(filter!);
    // print('requestEstate() cluster : ${cluster!.data!.totalCount()}');
    // filterModel.reset();
    // int cnt = await NetAPI.article(cluster!.data!,
    //         (bodies)  {
    //       filterModel.config(bodies);
    //     },
    //         (step, totalStep) {
    //       _notifyOnStatus(step, totalStep);
    //       print('requestEstate() step : $step / $totalStep');
    //     });
    //
    // print('requestEstate() article : ${cnt}');
  }
}