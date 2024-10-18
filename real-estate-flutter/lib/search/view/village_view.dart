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
import 'package:real_estate/search/view/village_select_popup.dart';

class VillageView extends StatefulWidget {
  const VillageView({super.key});

  @override
  State<StatefulWidget> createState() => _VillageViewState();
}


class _VillageViewState extends State<VillageView> {
  late final EstateModel estateModel = di.inject();

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
              backgroundColor: WidgetStatePropertyAll<Color>(
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
              backgroundColor: WidgetStatePropertyAll<Color>(
                  Colors.blueAccent),
            ),
            onPressed: () {
              _showSelectPopup(estateModel.findVillage(estateModel.selectedGu));
            },
            child: Text(
                estateModel.selectedDong.isEmpty ? '선택' : estateModel.selectedDong,
                style: const TextStyle(fontSize: 18, color: Colors.white)
            ),
          ),
        ),
        Expanded(
         //alignment: Alignment.centerRight,
          child: Container(
            width: 100,
            padding: const EdgeInsets.only(right: 20),
            alignment: Alignment.centerRight,
            child: TextButton(
              style: ButtonStyle (
                backgroundColor: WidgetStatePropertyAll<Color>(
                    estateModel.selectedDong.isNotEmpty ? Colors.green : Colors.grey),
              ),
              onPressed: () {
                if (estateModel.selectedDong.isNotEmpty) {
                _search();
                }
              },
              child: const Text(
                  ' 검색 ',
                  style: TextStyle(fontSize: 18, color: Colors.white)
              ),
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

  void _search() async {
    var progress = DialogForm().showProgress(context);
    try {
      estateModel.filter = await NetAPI.searchResult(SearchOption.basic(
        selectedGu: estateModel.selectedGu,
        selectedDong: estateModel.selectedDong,
      ));
      print('_search() filter : ${estateModel.filter!.lat} / ${estateModel.filter!.lon}');
      estateModel.cluster = await NetAPI.cluster(estateModel.filter!);
      print('_search() cluster : ${estateModel.cluster!.data?.totalCount()}');
      // var bodyList = await NetAPI.article(estateModel.cluster?.data?.article ?? []);
      // if (bodyList.isNotEmpty) {
      //   estateModel.bodyList.addAll(bodyList);
      // }
      // print('_search() article : ${estateModel.bodyList.length}');
    }
    catch (e) {
      print('_search() error : $e');
    }
    finally {
      progress.dismiss();
    }
  }
}