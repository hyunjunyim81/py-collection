import 'package:flutter/material.dart';
import 'package:real_estate/app/app_context.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/model/filter_model.dart';
import 'package:real_estate/model/view/office.dart';
import 'package:real_estate/model/view/thing.dart';
import 'package:real_estate/search/view/info_ltem_view.dart';

class InfoListView extends StatefulWidget {
  const InfoListView({super.key});

  @override
  State<StatefulWidget> createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> {
  late final FilterModel filterModel = di.inject();
  List<Thing> things = [];

  @override
  void initState() {
    super.initState();
    filterModel.addUpdateCallback(_onFilterUpdate);

  }

  @override
  Widget build(BuildContext context) {
    _setupThings();
    return ListView.builder(
        itemCount: things.length,
        itemBuilder: (BuildContext context, int index) {
          return InfoItemView(thing: things[index]);
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
    filterModel.removeUpdateCallback(_onFilterUpdate);
  }

  void _onFilterUpdate() {
    setState(() {
      print('onFilterUpdate ${filterModel.getThings().length}');
    });
  }

  void _setupThings() {
    if (AppContext.listDummy) {
      things = [Office.dummy()];
    } else {
      things = filterModel.getThings();
    }
  }
}