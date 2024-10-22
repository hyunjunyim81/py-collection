import 'package:real_estate/api/data/article_response.dart';
import 'package:real_estate/api/table/trade_type.dart';
import 'package:real_estate/model/view/thing.dart';

abstract class SalesType<T>
{
  List<Thing> salesBuy = [];
  List<Thing> monthlyRent = [];
  List<Thing> shortTernRent = [];

  void reset() {
    salesBuy.clear();
    monthlyRent.clear();
    shortTernRent.clear();
  }

  void config(Body body)
  {
    switch (body.tradTpNm) {
      case A1_name:
        salesBuy.add(create(body) as Thing);
        break;
      case B2_name:
        monthlyRent.add(create(body) as Thing);
        break;
      case B3_name:
        shortTernRent.add(create(body) as Thing);
        break;
      default:
        break;
    }
  }

  T create(Body body);

  List<Thing> getThings(TradeType treadType) {
    switch (treadType) {
      case TradeType.A1:
        return salesBuy;
      case TradeType.B2:
        return monthlyRent;
      case TradeType.B3:
        return shortTernRent;
      default:
        return [];
    }
  }
}