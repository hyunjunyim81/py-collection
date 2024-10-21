import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_estate/api/table/search_option.dart';
import 'package:real_estate/app/view/screen_view.dart';
import 'package:real_estate/model/estate_model.dart';
import 'package:real_estate/model/filter_model.dart';
import 'package:window_manager/window_manager.dart';
import 'api/net_api.dart';
import 'common/di/extension_get_it.dart';

void getItRegister() {
  di.scopeClear();
  //singleton
  di.registerSingleton<EstateModel>(EstateModel());
  di.registerSingleton<FilterModel>(FilterModel());
}

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(640, 480));
    WindowManager.instance.setSize(const Size(640, 480));
  }
  getItRegister();
  runApp(const ScreenView());
}
