import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/table/role_type.dart';
import 'package:real_estate/api/table/trade_type.dart';
import 'package:real_estate/search/model/sales_type_dt.dart';
import 'package:real_estate/search/model/sales_type_office.dart';
import 'package:real_estate/search/model/thing.dart';

class FilterRepo
{
   static const double minRangeValue = 0;
   static const double maxRangeValue = 1001;
   static const RangeValues defaultRangeValues = RangeValues(minRangeValue, maxRangeValue);

   RoleType filterRoleType = RoleType.SG;
   TradeType filterTradeType = TradeType.A1;

   RangeValues filterRangeValues = defaultRangeValues;

   SalesTypeDT downtown = SalesTypeDT();
   SalesTypeOffice office = SalesTypeOffice();
   List<VoidCallback> updateCallback = [];

   void addUpdateCallback(VoidCallback callback) {
      if (!updateCallback.contains(callback)) {
         updateCallback.add(callback);
      }
   }

   void removeUpdateCallback(VoidCallback callback) {
      updateCallback.remove(callback);
   }

   void notifyUpdateCallback() {
      for (var callback in updateCallback) {
         try {
         callback();
         }
         catch (e) {
            //print(e);
         }
      }
   }

   void reset() {
      office.reset();
      downtown.reset();
   }

   Future<void> config(List<Body> bodies) async {
      for (var body in bodies) {
         //print('FilterModel body ${body.rletTpNm}');
         switch (body.rletTpNm) {
            case '사무실':
               office.config(body);
               break;
            case '상가':
               downtown.config(body);
               break;
            default:
               break;
         }
      }
   }

   List<Thing> getThings() {
      switch (filterRoleType) {
         case RoleType.SMS:
            return office.getThings(filterTradeType);
         case RoleType.SG:
            return downtown.getThings(filterTradeType);
         default:
            return [];
      }
   }

   String spaceRangeString(RangeValues rangeValues) {
      var start = '';
      var end = '';
      if (rangeValues.start != minRangeValue) {
         start = rangeValues.start.toInt().toString();
      }

      if (rangeValues.end != maxRangeValue) {
         end = rangeValues.end.toInt().toString();
      }
      return start.isEmpty && end.isEmpty ? '전체' : '$start~$end평';
   }
}