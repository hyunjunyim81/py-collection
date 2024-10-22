import 'package:real_estate/api/data/article_response.dart';

import 'down_town.dart';
import 'sales_type.dart';

class SalesTypeDT extends SalesType<DownTown>
{
  @override
  DownTown create(Body body) {
    return DownTown.config(body);
  }
}