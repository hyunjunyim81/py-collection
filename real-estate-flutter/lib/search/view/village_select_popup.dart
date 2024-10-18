import 'dart:math';

import 'package:flutter/material.dart';
import 'package:real_estate/api/table/village.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/view/dialog_form.dart';
import 'package:real_estate/model/estate_model.dart';

class VillageSelectPopup {
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

  void show(BuildContext context, Village? selectedVillage, Function reload) {
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
              child: _VillageSelectView(selectedVillage: selectedVillage,
                  reload: reload, popup: this),
            )
        );
      },
    );
  }
}

class _VillageSelectView extends StatefulWidget {
  final VillageSelectPopup popup;
  final Function reload;
  Village? selectedVillage;

  _VillageSelectView({super.key, this.selectedVillage, required this.popup, required this.reload});

  @override
  State<StatefulWidget> createState() => _VillageSelectViewState();
}

class _VillageSelectViewState extends State<_VillageSelectView> {
  late final EstateModel estateModel = di.inject();

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  Widget _body() {
    return Column(
      children: [
        _topButtons(),
        Container(
          color: Colors.black26,
          height: 2,
          margin: const EdgeInsets.only(bottom: 10, top: 10),
        ),
        Expanded(
          child: widget.selectedVillage == null ? _gridFromGu() : _gridFromDong(),
        ),
      ],
    );
  }

  Widget _gridFromGu() {
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      itemCount: estateModel.villageList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 3,),
      itemBuilder: (context, itemIndex) {
        return _itemForGu(estateModel.villageList[itemIndex]);
      },
    );
  }

  Widget _itemForGu(Village village) {
    return TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                  width: 2,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
              )
          ),
        ),
        onPressed: () {
          setState(() {
            widget.selectedVillage = village;
          });
        },
        child: Text(
            village.gu,
            style: const TextStyle(fontSize: 20, color: Colors.black87))
    );
  }

  Widget _gridFromDong() {
    return GridView.builder(
      shrinkWrap: true,
      //physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.selectedVillage?.dongList.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 3,),
      itemBuilder: (context, itemIndex) {
        return _itemForDong(widget.selectedVillage!.dongList[itemIndex]);
      },
    );
  }

  Widget _itemForDong(String dong) {
    return TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(
                  width: 2,
                  color: Colors.grey,
                  style: BorderStyle.solid,
                ),
              )
          ),
        ),
        onPressed: () {
          setState(() {
            estateModel.selectedGu = widget.selectedVillage!.gu;
            estateModel.selectedDong = dong;
            widget.reload.call();
            widget.popup.dismiss();
          });
        },
        child: Text(
            dong,
            style: const TextStyle(fontSize: 20, color: Colors.black87))
    );
  }

  Widget _topButtons() {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 0, right: 15, left: 15),
      width: double.maxFinite,
      height: 50,
      child: Row(
        children: [
          const SizedBox(width: 80,),
          Expanded(
              child: Container(alignment: Alignment.center,
                child: Text(widget.selectedVillage?.gu ?? "서울시",
                    style: const TextStyle(fontSize: 28, color: Colors.black)),
              ),
          ),
          SizedBox(
            width: 80,
            child: _closeButton()
          ),
        ],
      ),
    );
  }

  Widget _closeButton() {
    return TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
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
          widget.popup.dismiss();
        },
        child: const Text(
            '닫기',
            style: const TextStyle(fontSize: 20, color: Colors.black))
    );
  }
}