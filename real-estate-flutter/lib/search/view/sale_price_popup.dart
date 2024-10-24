import 'package:flutter/material.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/util/num_util.dart';
import 'package:real_estate/common/view/dialog_form.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/repo/filter_repo.dart';

class SalePricePopup {
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
              child: _SalePriceView(reload: reload, popup: this),
            )
        );
      },
    );
  }
}

class _SalePriceView extends StatefulWidget {
  final SalePricePopup popup;
  final Function reload;

  _SalePriceView({super.key, required this.popup, required this.reload});

  @override
  State<StatefulWidget> createState() => _SalePriceViewState();
}

class _SalePriceViewState extends State<_SalePriceView> {
  late final EstateRepo estateRepo = di.inject();
  late final FilterRepo filterRepo = di.inject();
  late RangeValues _currentRangeValues;
  final List<List<double>> _rangeUnits = [[0, 5000], [5000, 10000],
    [10000, 20000], [20000, 30000], [30000, 40000],
    [40000, 50000], [50000, 60000], [60000, 70000],
    [70000, 80000], [80000, 90000], [90000, 100000],
    [100000, 150000], [150000, 200000], [200000, 400000],
    [400000, 600000], [600000, 800000], [800000, 1000000],
    [1000000, 1000001]];

  @override
  void initState() {
    super.initState();
    _currentRangeValues = filterRepo.filterSalePriceValues;
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
        max: 1000001,
        divisions: 1000001,
        labels: RangeLabels(
            _currentRangeValues.start.toInt().toString(),
            _currentRangeValues.end == FilterRepo.maxSalePriceValue
            ? '전체' : _currentRangeValues.end.toInt().toString(),
        ),
        onChanged: (RangeValues values) {
          setState(() {
            if (values.end > values.start) {
              _currentRangeValues = values;
            } else {
              if (values.start == FilterRepo.minSpaceValue) {
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
              child: Text('매매/보증금  ${filterRepo.salePriceRangeString(_currentRangeValues)}',
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
          filterRepo.filterSalePriceValues = _currentRangeValues;
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
      itemCount: _rangeUnits.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, childAspectRatio: 3,),
      itemBuilder: (context, itemIndex) {
        return _itemSpaceUnit(_rangeUnits[itemIndex]);
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
            spaceUnits.last == FilterRepo.maxSalePriceValue
                ? '100억~'
                : '${(spaceUnits.last / 10000).toStringAsDynamic(1)}억',
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