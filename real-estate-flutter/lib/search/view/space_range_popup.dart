import 'package:flutter/material.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/view/dialog_form.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/repo/filter_repo.dart';

class SpaceRangePopup {
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
              child: _SpaceRangeView(reload: reload, popup: this),
            )
        );
      },
    );
  }
}

class _SpaceRangeView extends StatefulWidget {
  final SpaceRangePopup popup;
  final Function reload;

  _SpaceRangeView({super.key, required this.popup, required this.reload});

  @override
  State<StatefulWidget> createState() => _SpaceRangeViewState();
}

class _SpaceRangeViewState extends State<_SpaceRangeView> {
  late final EstateRepo estateRepo = di.inject();
  late final FilterRepo filterRepo = di.inject();
  late RangeValues _currentSpaceValues;
  final List<List<double>> _spaceRangeUnits = [[0, 50], [50, 100], [100, 200],
    [200, 300], [300, 400], [400, 500], [500, 600], [600, 700],
    [700, 800], [800, 900], [900, 1000], [1000, 1001]];

  @override
  void initState() {
    super.initState();
    _currentSpaceValues = filterRepo.filterSpaceValues;
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
        values: _currentSpaceValues,
        min: 0,
        max: 1001,
        divisions: 1001,
        labels: RangeLabels(
            _currentSpaceValues.start.toInt().toString(),
            _currentSpaceValues.end == 1001
            ? '전체' : _currentSpaceValues.end.toInt().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            if (values.end > values.start) {
              _currentSpaceValues = values;
            } else {
              if (values.start == FilterRepo.minSpaceValue) {
                _currentSpaceValues = const RangeValues(0, 1);
              } else {
                _currentSpaceValues = RangeValues(values.end - 1, values.end);
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
              child: Text('면적  ${filterRepo.spaceRangeString(_currentSpaceValues)}',
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
          filterRepo.filterSpaceValues = _currentSpaceValues;
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
          color: _includeRange(spaceUnits) ? Colors.green[300] : Colors.white, //background color
          border: Border.all(
              color: Colors.grey // border color
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(
            spaceUnits.last == FilterRepo.maxSpaceValue
                ? '1000평~'
                : '${spaceUnits.last.toInt().toString()}평',
            style: const TextStyle(fontSize: 20, color: Colors.black87)
        )

    );
  }

  bool _includeRange(List<double> spaceRange) {
    if (_currentSpaceValues.start <= spaceRange.first && spaceRange.first <= _currentSpaceValues.end){
      return true;
    }
    if (_currentSpaceValues.start <= spaceRange.last && spaceRange.last <= _currentSpaceValues.end){
      return true;
    }
    return false;
  }
}