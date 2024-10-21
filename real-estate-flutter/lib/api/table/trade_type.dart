const String A1_name = '매매';
const String B1_name = '전세';
const String B2_name = '월세';
const String B3_name = '단기임대';

enum TradeType
{
  A1(A1_name, 'A1'),
  B1(B1_name, 'B1'),
  B2(B2_name, 'B2'),
  B3(B3_name, 'B3');

  final String name;
  final String key;
  const TradeType(this.name, this.key);
}