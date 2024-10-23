import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/table/role_type.dart';
import 'package:real_estate/api/table/trade_type.dart';
import 'package:real_estate/common/util/num_util.dart';
import 'package:real_estate/search/model/sales_type_dt.dart';
import 'package:real_estate/search/model/sales_type_office.dart';
import 'package:real_estate/search/model/thing.dart';

class FilterRepo
{
   static const double minSpaceValue = 0;
   static const double maxSpaceValue = 1001;
   static const RangeValues defaultSpaceValues = RangeValues(minSpaceValue, maxSpaceValue);

   static const double minSalePriceValue = 0;
   static const double maxSalePriceValue = 1000001;
   static const RangeValues defaultSalePriceValues = RangeValues(minSalePriceValue, maxSalePriceValue);

   static const double minRentPriceValue = 0;
   static const double maxRentPriceValue = 10001;
   static const RangeValues defaultRentPriceValues = RangeValues(minRentPriceValue, maxRentPriceValue);

   RoleType filterRoleType = RoleType.SG;
   TradeType filterTradeType = TradeType.A1;

   RangeValues filterSpaceValues = defaultSpaceValues;
   RangeValues filterSalePriceValues = defaultSalePriceValues;
   RangeValues filterRentPriceValues = defaultRentPriceValues;

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
      if (rangeValues.start != minSpaceValue) {
         start = rangeValues.start.toInt().toString();
      }

      if (rangeValues.end != maxSpaceValue) {
         end = rangeValues.end.toInt().toString();
      }
      return start.isEmpty && end.isEmpty ? '전체' : '$start~$end평';
   }

   String salePriceRangeString(RangeValues rangeValues) {
      var start = '';
      var end = '';
      if (rangeValues.start != minSalePriceValue) {
         start = (rangeValues.start / 10000).toStringAsDynamic(1);
      }

      if (rangeValues.end != maxSalePriceValue) {
         end = (rangeValues.end / 10000).toStringAsDynamic(1);
      }
      return start.isEmpty && end.isEmpty ? '전체'
          : '${start}~${end}억';
   }

   String rentPriceRangeString(RangeValues rangeValues) {
      var start = '';
      var end = '';
      if (rangeValues.start != minRentPriceValue) {
         start = rangeValues.start.toInt().toString();
      }

      if (rangeValues.end != maxRentPriceValue) {
         end = rangeValues.end.toInt().toString();
      }
      return start.isEmpty && end.isEmpty ? '전체'
          : '${start}~${end}만';
   }

}