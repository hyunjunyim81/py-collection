enum TradeType
{
  A1('매매', 'A1'),
  B1('전세', 'B1'),
  B2('월세', 'B2'),
  B3('단기임대', 'B3');

  final String name;
  final String key;
  const TradeType(this.name, this.key);
}