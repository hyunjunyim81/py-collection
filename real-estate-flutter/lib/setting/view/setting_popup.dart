import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/api/net_cache.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/view/dialog_form.dart';

class SettingPopup {
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
              child: _SettingPopupView(reload: reload, popup: this),
            )
        );
      },
    );
  }
}

class _SettingPopupView extends StatefulWidget {
  final SettingPopup popup;
  final Function reload;

  _SettingPopupView({super.key, required this.popup, required this.reload});

  @override
  State<StatefulWidget> createState() => _SettingPopupViewState();
}

class _SettingPopupViewState extends State<_SettingPopupView> {

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
          child: ListView.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                switch(index) {
                  case 0:
                    return SizedBox(height: 40, child: _cacheSetting(),);
                  default:
                    return const SizedBox(height: 1,);
                }
              }
          ),
        ),
      ],
    );
  }

  Widget _cacheSetting() {
    return Row(
        children: [
          const SizedBox(width: 10,),
          const Text(
              '캐쉬 관리',
              style: TextStyle(fontSize: 20, color: Colors.black)
          ),
          Expanded(child: Container()),
          IconButton(
              onPressed: () async {
                await NetCache.openCacheDir();
              },
              icon: const Icon(Icons.folder)
          ),
          IconButton(
              onPressed: () async {
                await NetCache.clearCacheDir();
                DialogForm().showPopup(
                    context: context,
                    title: '알림',
                    message: '캐쉬 데이터가 모두 삭제 되었습니다.',
                    closeText: '확인',
                    pressed: null);
              },
              icon: const Icon(Icons.delete)
          ),
        ]
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
                child: const Text('설정',
                    style: TextStyle(fontSize: 28, color: Colors.black)),
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
          widget.popup.dismiss();
        },
        child: const Text(
            '닫기',
            style: TextStyle(fontSize: 20, color: Colors.black))
    );
  }
}