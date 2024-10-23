import 'dart:math';

import 'package:flutter/material.dart';
import 'package:real_estate/api/table/village.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/view/dialog_form.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/repo/filter_repo.dart';

class SpaceSelectPopup {
  bool _isDismiss = false;
  late DialogRoute route;

  void dismiss() {
    _isDismiss = true;
  }

  Future<void> _untilDismissCheck(BuildContext context) async {
    Future.doWhile(() async {
      if (_isDismiss) {
        Navigator.of(context).removeRoute(route);
        return false;
      }
      await Future.delayed(
        const Duration(milliseconds: 100), () => {},
      );
      return true;
    });
  }

  void show(BuildContext context, Function reload) {
    route = DialogForm.generateDialog(context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _untilDismissCheck(context);
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
            ),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: 600,
              height: 400,
              child: _SpaceSelectView(reload: reload, popup: this),
            )
        );
      },
    );
  }
}

class _SpaceSelectView extends StatefulWidget {
  final SpaceSelectPopup popup;
  final Function reload;

  _SpaceSelectView({super.key, required this.popup, required this.reload});

  @override
  State<StatefulWidget> createState() => _SpaceSelectViewState();
}

class _SpaceSelectViewState extends State<_SpaceSelectView> {
  late final EstateRepo estateRepo = di.inject();
  late final FilterRepo filterRepo = di.inject();
  late RangeValues _currentRangeValues;
  final List<List<double>> _spaceRangeUnits = [[0, 50], [50, 100], [100, 200],
    [200, 300], [300, 400], [400, 500], [500, 600], [600, 700],
    [700, 800], [800, 900], [900, 1000], [1000, 1001]];

  @override
  void initState() {
    super.initState();
    _currentRangeValues = filterRepo.filterRangeValues;
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Column(
      children: [
        _topButtons(),
        _topRangeSlider(),
        Container(
          color: Colors.black26,
          height: 2,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
        ),
        Expanded(
          child: _gridSpaceUnit(),
        ),
      ],
    );
  }

  Widget _topRangeSlider() {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 0, right: 15, left: 15),
      width: double.maxFinite,
      height: 50,
      child: RangeSlider(
        values: _currentRangeValues,
        min: 0,
        max: 1001,
        divisions: 1001,
        labels: RangeLabels(
            _currentRangeValues.start.toInt().toString(),
            _currentRangeValues.end == 1001
            ? '무한' : _currentRangeValues.end.toInt().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            if (values.end > values.start) {
              _currentRangeValues = values;
            } else {
              if (values.start == FilterRepo.minRangeValue) {
                _currentRangeValues = const RangeValues(0, 1);
              } else {
                _currentRangeValues = RangeValues(values.end - 1, values.end);
              }
            }
          });
        },
      ),
    );
  }

  Widget _topButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 0, right: 15, left: 15),
      width: double.maxFinite,
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 10,),
          Expanded(
            child: Container(alignment: Alignment.centerLeft,
              child: Text('면적  ${filterRepo.spaceRangeString(_currentRangeValues)}',
                  style: const TextStyle(fontSize: 24, color: Colors.black)),
            ),
          ),
          Container(
              width: 100,
              alignment: Alignment.center,
              child: _closeButton()
          ),
        ],
      ),
    );
  }

  Widget _closeButton() {
    return TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: const BorderSide(
                  width: 2,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
              )
          ),
        ),
        onPressed: () {
          filterRepo.filterRangeValues = _currentRangeValues;
          widget.reload();
          widget.popup.dismiss();
        },
        child: const Text(
            '닫기',
            style: TextStyle(fontSize: 20, color: Colors.black))
    );
  }

  Widget _gridSpaceUnit() {
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      itemCount: _spaceRangeUnits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, childAspectRatio: 2,),
      itemBuilder: (context, itemIndex) {
        return _itemSpaceUnit(_spaceRangeUnits[itemIndex]);
      },
    );
  }

  Widget _itemSpaceUnit(List<double> spaceUnits) {
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _includeRange(spaceUnits) ? Colors.greenAccent : Colors.white, //background color
          border: Border.all(
              color: Colors.grey // border color
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
            spaceUnits.last == 1001
                ? '1000~평'
                : '${spaceUnits.last.toInt().toString()}평',
            style: const TextStyle(fontSize: 20, color: Colors.black87)
        )

    );
  }

  bool _includeRange(List<double> spaceRange) {
    if (_currentRangeValues.start <= spaceRange.first && spaceRange.first <= _currentRangeValues.end){
      return true;
    }
    if (_currentRangeValues.start <= spaceRange.last && spaceRange.last <= _currentRangeValues.end){
      return true;
    }
    return false;
  }
}