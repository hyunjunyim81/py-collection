import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:real_estate/api/data/filter.dart';
import 'package:real_estate/api/table/search_option.dart';

class ExcelReader {
  static Future<bool> matched(Filter filter) async {
    ByteData data = await rootBundle.load("assets/excel/estate_location.xlsx");
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);
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
}