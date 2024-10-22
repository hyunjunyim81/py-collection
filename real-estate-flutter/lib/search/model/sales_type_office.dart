import 'package:real_estate/api/data/article_response.dart';

import 'office.dart';
import 'sales_type.dart';

class SalesTypeOffice extends SalesType<Office>
{
  @override
  Office create(Body body) {
    return Office.config(body);
  }
}