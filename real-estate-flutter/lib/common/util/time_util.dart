import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtil
{
  static const String yyyy_MM_ddT_HH_mm_ssZ = 'yyyy-MM-ddTHH:mm:ssZ';
  static const String yyyy_MM_dd__HH_mm = 'yyyy-MM-dd HH:mm';
  static const String yyyy_MM_dd = 'yyyy-MM-dd';
  static const String HH_mm = 'HH:mm';
  static const String dd = 'dd';
  static const String dd_day_HH_mm = 'dd일 HH:mm';
}

extension StringFormatEx on String {
  String isoToFormat(String pattern) {
    var time = DateFormat(TimeUtil.yyyy_MM_ddT_HH_mm_ssZ).parse(this, true).toLocal();
    return DateFormat(pattern).format(time);
  }
}

extension DateTimeEx on DateTime {
  DateTime firstDay() {
    return DateTime(year, month, 1);
  }

  DateTime lastDay() {
    var beginningNextMonth = (month < 12) ? DateTime(
        year, month + 1, 1) : DateTime(year + 1, 1, 1);
    var lastDay = beginningNextMonth
        .subtract(const Duration(days: 1))
        .day;
    return DateTime(year, month, lastDay);
  }

  DateTime timeToDate(TimeOfDay timeOfDay) {
    return DateTime(year, month, day, timeOfDay.hour, timeOfDay.minute);
  }

  String toFormat(String pattern) {
    return DateFormat(pattern).format(this);
  }
}