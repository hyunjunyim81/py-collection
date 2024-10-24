import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/table/village.dart';

class ExcelReader {

  static Future<Excel> _load() async {
    ByteData data = await rootBundle.load("assets/excel/estate_location.xlsx");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return Excel.decodeBytes(bytes);
  }

  static Future<bool> matched(Filter filter) async {
    var excel = await _load();
    try {
      Sheet sheet = excel[filter.gu];
      for (List<Data?> column in sheet.rows) {
        if (column.first?.value.toString() == filter.dong) {
          String url = column[1]?.value.toString() ?? '';
          if (url.isEmpty) break;

          var params = url.split('?')[1].split('&');
          Map<String, String> entry = {};
          for (String param in params) {
            var kv = param.split('=');
            entry[kv[0]] = kv[1];
          }

          if (entry.isNotEmpty) {
            filter.matched(entry);
            return true;
          }
          break;
        }
      }
    }
    catch (e) {
      print('matched error : $e');
    }

    return false;
  }

  static Future<List<Village>> village() async {
    var excel = await _load();
    List<Village> result = [];
    try {
      for (var entry in excel.sheets.entries) {
        var gu = entry.value.sheetName;
        List<String> dongList = [];
        for (List<Data?> column in entry.value.rows) {
          if (column.first != null) {
            dongList.add(column.first!.value.toString());
          }
        }
        if (dongList.isNotEmpty) {
          result.add(Village(gu: gu, dongList: dongList));
        }
      }
    }
    catch (e) {
      print('village error : $e');
    }
    return result;
  }
}