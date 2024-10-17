import 'dart:math';

import 'table/device_name.dart';

class NetHeader {
  static const List<DeviceName> deviceNames = DeviceName.values;
  static const String userAgentKey = "User-Agent";

  static const Map<String, String> defaultHeaders = {
    "User-Agent":"Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36"
  };

  static Duration randomDuration() {
    return Duration(microseconds: 200 + Random().nextInt(500));
  }

  static Map<String, String> randomHeader() {
    var value = _userAgentValue(deviceNames[Random().nextInt(deviceNames.length)]);
    //print('randomHeader value : $value');
    Map<String, String> headers = {};
    headers[userAgentKey] = value;
    return headers;
  }

  static String _userAgentValue(DeviceName deviceName) {
    return 'Mozilla/5.0 (Linux; Android 8.0.0; ${deviceName.model} Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36';
  }
}