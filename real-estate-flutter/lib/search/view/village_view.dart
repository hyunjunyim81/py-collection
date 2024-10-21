import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:real_estate/api/net_api.dart';
import 'package:real_estate/api/table/excel_reader.dart';
import 'package:real_estate/api/table/search_option.dart';
import 'package:real_estate/api/table/village.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/view/dialog_form.dart';
import 'package:real_estate/model/estate_model.dart';
import 'package:real_estate/model/filter_model.dart';
import 'package:real_estate/search/view/village_select_popup.dart';
import 'package:real_estate/setting/view/setting_popup.dart';

import 'search_view.dart';

class VillageView extends StatefulWidget {
  const VillageView({super.key});

  @override
  State<StatefulWidget> createState() => _VillageViewState();
}


class _VillageViewState extends State<VillageView> {
  late final EstateModel estateModel = di.inject();
  late final FilterModel filterModel = di.inject();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _config();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                estateModel.selectedGu.isEmpty ? '선택' : estateModel.selectedGu,
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
              _showSelectPopup(estateModel.findVillage(estateModel.selectedGu));
            },
            child: Text(
                estateModel.selectedDong.isEmpty ? '선택' : estateModel
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
                        if (estateModel.selectedDong.isNotEmpty) {
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

  void _config() async {
    var list = await ExcelReader.village();
    if (list.isNotEmpty) {
      setState(() {
        estateModel.villageList.clear();
        estateModel.villageList.addAll(list);
        print('Village : ${estateModel.villageList.length}');
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
      await estateModel.requestEstate(filterModel);
      filterModel.notifyUpdateCallback();
    }
    catch (e) {
      print('_search() requestEstate error : $e');
    }
    finally {
      progress.dismiss();
    }
  }
}