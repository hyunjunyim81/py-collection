const String A1_name = '매매';
const String B1_name = '전세';
const String B2_name = '월세';
const String B3_name = '단기임대';

const String A1_code = 'A1';
const String B1_code = 'B1';
const String B2_code = 'B2';
const String B3_code = 'B3';

enum TradeType
{
  A1(A1_name, A1_code),
  B1(B1_name, B1_code),
  B2(B2_name, B2_code),
  B3(B3_name, B3_code);

  final String name;
  final String key;
  const TradeType(this.name, this.key);
}