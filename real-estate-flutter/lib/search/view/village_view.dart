import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/api/table/excel_reader.dart';
import 'package:real_estate/api/table/role_type.dart';
import 'package:real_estate/api/table/trade_type.dart';
import 'package:real_estate/api/table/village.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/view/dialog_form.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/repo/filter_repo.dart';
import 'package:real_estate/search/view/village_select_popup.dart';
import 'package:real_estate/setting/view/setting_popup.dart';

import 'space_range_popup.dart';

class VillageView extends StatefulWidget {
  const VillageView({super.key});

  @override
  State<StatefulWidget> createState() => _VillageViewState();
}


class _VillageViewState extends State<VillageView> {
  late final EstateRepo estateRepo = di.inject();
  late final FilterRepo filterRepo = di.inject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _config();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _firstColumn(),
        _secondColumn(),
        _thirdColumn(),
      ],
    );
  }

  Widget _firstColumn() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        SizedBox(
          width: 100,
          child: TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Colors.blueAccent),
            ),
            onPressed: () {
              _showSelectPopup(null);
            },
            child: Text(
                estateRepo.selectedGu.isEmpty ? '선택' : estateRepo.selectedGu,
                style: const TextStyle(fontSize: 18, color: Colors.white)
            ),
          ),
        ),
        const SizedBox(width: 10,),
        SizedBox(
          width: 100,
          child: TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(
                  Colors.blueAccent),
            ),
            onPressed: () {
              _showSelectPopup(estateRepo.findVillage(estateRepo.selectedGu));
            },
            child: Text(
                estateRepo.selectedDong.isEmpty ? '선택' : estateRepo
                    .selectedDong,
                style: const TextStyle(fontSize: 18, color: Colors.white)
            ),
          ),
        ),
        Expanded(
          //alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        if (estateRepo.selectedDong.isNotEmpty) {
                          _search();
                        }
                      },
                      icon: const Icon(Icons.search)
                  ),
                  IconButton(
                      onPressed: () {
                        _showSettingPopup();
                      },
                      icon: const Icon(Icons.settings)
                  )
                ]
            ),
          ),
        )
      ],
    );
  }

  Widget _secondColumn() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        _roleTypeSG(),
        _roleTypeSMS(),
        const SizedBox(width: 30,),
        _tradeTypeA1(),
        _tradeTypeB2(),
        _tradeTypeB3(),
      ],
    );
  }

  Widget _roleTypeSG() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterRepo.filterRoleType = RoleType.SG;
          filterRepo.notifyUpdateCallback();
        });
      },
      child: Container(
        width: 65,
        height: 40,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: filterRepo.filterRoleType == RoleType.SG
                  ? const Icon(
                Icons.radio_button_checked, color: Colors.blue,)
                  : const Icon(
                Icons.radio_button_off, color: Colors.black,),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 40,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(
                RoleType.SG.name,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleTypeSMS() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterRepo.filterRoleType = RoleType.SMS;
          filterRepo.notifyUpdateCallback();
        });
      },
      child: Container(
        width: 85,
        height: 40,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: filterRepo.filterRoleType == RoleType.SMS
                  ? const Icon(
                Icons.radio_button_checked, color: Colors.blue,)
                  : const Icon(
                Icons.radio_button_off, color: Colors.black,),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 60,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(
                RoleType.SMS.name,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tradeTypeA1() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterRepo.filterTradeType = TradeType.A1;
          filterRepo.notifyUpdateCallback();
        });
      },
      child: Container(
        width: 85,
        height: 40,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: filterRepo.filterTradeType == TradeType.A1
                  ? const Icon(
                Icons.radio_button_checked, color: Colors.blue,)
                  : const Icon(
                Icons.radio_button_off, color: Colors.black,),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 60,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(
                TradeType.A1.name,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tradeTypeB2() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterRepo.filterTradeType = TradeType.B2;
          filterRepo.notifyUpdateCallback();
        });
      },
      child: Container(
        width: 85,
        height: 40,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: filterRepo.filterTradeType == TradeType.B2
                  ? const Icon(
                Icons.radio_button_checked, color: Colors.blue,)
                  : const Icon(
                Icons.radio_button_off, color: Colors.black,),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 60,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(
                TradeType.B2.name,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tradeTypeB3() {
    return GestureDetector(
      onTap: () {
        setState(() {
          filterRepo.filterTradeType = TradeType.B3;
          filterRepo.notifyUpdateCallback();
        });
      },
      child: Container(
        width: 105,
        height: 40,
        color: Colors.white,
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: filterRepo.filterTradeType == TradeType.B3
                  ? const Icon(
                Icons.radio_button_checked, color: Colors.blue,)
                  : const Icon(
                Icons.radio_button_off, color: Colors.black,),
            ),
            const SizedBox(width: 5,),
            Container(
              width: 80,
              height: 30,
              alignment: Alignment.centerLeft,
              child: Text(
                TradeType.B3.name,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _config() async {
    var list = await ExcelReader.village();
    if (list.isNotEmpty) {
      setState(() {
        estateRepo.villageList.clear();
        estateRepo.villageList.addAll(list);
        print('Village : ${estateRepo.villageList.length}');
      });
    }
  }

  void _showSelectPopup(Village? selectedVillage) {
    VillageSelectPopup().show(context, selectedVillage, _update);
  }

  void _update() {
    setState(() {

    });
  }

  void _showSettingPopup() {
    SettingPopup().show(context, _updateFromSetting);
  }

  void _updateFromSetting() {
    //filterModel.notifyUpdateCallback();
  }

  void _search() async {
    var progress = DialogForm().showProgress(context);
    try {
      estateRepo.requestEstate(filterRepo);
      //filterModel.notifyUpdateCallback();
    }
    catch (e) {
      print('_search() requestEstate error : $e');
    }
    finally {
      progress.dismiss();
    }
  }

  Widget _thirdColumn() {
    return Row(
      children: [
        const SizedBox(width: 20,),
        _space(),
        const SizedBox(width: 20,),
        _sale(),
        const SizedBox(width: 20,),
        _rent(),
      ],
    );
  }

  Widget _space() {
    return SizedBox(
      width: 140,
      height: 30,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: const BorderSide(
                width: 2,
                color: Colors.grey,
              ),
            )
          ),
        ),
        onPressed: _showSpacePopup,
        child: Text(
            '면적 ${filterRepo.spaceRangeString(filterRepo.filterSpaceValues)}',
            style: const TextStyle(fontSize: 14, color: Colors.black)
        ),
      ),
    );
  }

  void _showSpacePopup() {
    SpaceRangePopup().show(context, _update);
  }

  Widget _sale() {
    return SizedBox(
      width: 180,
      height: 30,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: const BorderSide(
                  width: 2,
                  color: Colors.grey,
                ),
              )
          ),
        ),
        onPressed: _showSpacePopup,
        child: Text(
            '매매/보증금 ${filterRepo.spaceRangeString(filterRepo.filterSpaceValues)}',
            style: const TextStyle(fontSize: 14, color: Colors.black)
        ),
      ),
    );
  }

  void _showSalePopup() {
    //SpaceRangePopup().show(context, _update);
  }

  Widget _rent() {
    return SizedBox(
      width: 180,
      height: 30,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: const BorderSide(
                  width: 2,
                  color: Colors.grey,
                ),
              )
          ),
        ),
        onPressed: _showSpacePopup,
        child: Text(
            '월세 ${filterRepo.spaceRangeString(filterRepo.filterSpaceValues)}',
            style: const TextStyle(fontSize: 14, color: Colors.black)
        ),
      ),
    );
  }

  void _showRentPopup() {
    //SpaceRangePopup().show(context, _update);
  }
}