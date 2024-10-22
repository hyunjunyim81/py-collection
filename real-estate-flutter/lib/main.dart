import 'dart:io';

import 'package:flutter/material.dart';
import 'package:real_estate/app/view/screen_view.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/repo/filter_repo.dart';
import 'package:window_manager/window_manager.dart';
import 'common/di/extension_get_it.dart';

void getItRegister() {
  di.scopeClear();
  //singleton
  di.registerSingleton<EstateRepo>(EstateRepo());
  di.registerSingleton<FilterRepo>(FilterRepo());

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
