import 'package:flutter/material.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/app/app_context.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/repo/filter_repo.dart';
import 'package:real_estate/search/model/office.dart';
import 'package:real_estate/search/model/thing.dart';
import 'package:real_estate/search/view/info_item_view.dart';

class InfoListView extends StatefulWidget {
  const InfoListView({super.key});

  @override
  State<StatefulWidget> createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> {
  late final EstateRepo estateModel = di.inject();
  late final FilterRepo filterModel = di.inject();
  List<Thing> things = [];
  String _statusMsg = '';

  @override
  void initState() {
    super.initState();
    filterModel.addUpdateCallback(_onFilterUpdate);
    estateModel.addOnStatus(_onStatus);
  }

  @override
  Widget build(BuildContext context) {
    _setupThings();
    //_statusMsg = "123";
    return Stack(
      children: [
        ListView.builder(
        itemCount: things.length,
            itemBuilder: (BuildContext context, int index) {
              return InfoItemView(thing: things[index]);
            }
        ),
        if (_statusMsg.isNotEmpty)
        Container(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(10),
              color: Colors.black38,
            ),
            child: Text(_statusMsg,
                style: const TextStyle(fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)
            ),
          )
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    filterModel.removeUpdateCallback(_onFilterUpdate);
    estateModel.removeOnStatus(_onStatus);
  }

  void _onFilterUpdate() {
    setState(() {
      print('onFilterUpdate ${filterModel.getThings().length}');
    });
  }

  void _setupThings() {
    if (AppContext.useDummy) {
      estateModel.filter = Filter.dummy();
      things = [Office.dummy()];
    } else {
      things = filterModel.getThings();
    }
  }

  void _onStatus(int step, int totalStep) {
    setState(() {
      if (step == totalStep) {
        _statusMsg = '';
      }
      else {
        _statusMsg = '  진행율 : $step/$totalStep...  ';
      }
      //print('info_list_view _onStatus : $step / $totalStep');
    });
  }
}