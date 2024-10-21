import 'dart:math';

import 'table/device_name.dart';

class NetHeader {
  static const List<DeviceName> deviceNames = DeviceName.values;
  static const String userAgentKey = "User-Agent";
  static List<int> _histories = [];

  static const Map<String, String> defaultHeaders = {
    "User-Agent":"Mozilla/5.0 (Linux; Android 8.0.0; SM-G955U Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36"
  };

  static Duration randomDuration() {
    return Duration(microseconds: 500 + Random().nextInt(500));
  }

  static Future<Map<String, String>> randomHeader() async {
    var value = _userAgentValue(await getRandomDeviceName());
    //print('randomHeader value : $value');
    Map<String, String> headers = {};
    headers[userAgentKey] = value;
    return headers;
  }

  static String _userAgentValue(DeviceName deviceName) {
    return 'Mozilla/5.0 (Linux; Android 8.0.0; ${deviceName.model} Build/R16NW) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36';
  }

  static Future<DeviceName> getRandomDeviceName() async {
    int ret = -1;
    do
    {
      ret = Random().nextInt(deviceNames.length);
      await Future.delayed(const Duration(milliseconds: 3));
      //print('getRandomDeviceName index : $ret / $histories');
    } while(_histories.contains(ret));

    if (ret != -1) _histories.add(ret);
    if (_histories.length > 10) _histories.removeAt(0);
    //print('getRandomDeviceName ${deviceNames[ret != -1 ? ret : 0]}');
    return deviceNames[ret != -1 ? ret : 0];
  }
}