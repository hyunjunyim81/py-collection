enum RoleType
{
  SG('상가', 'SG'),
  SMS('사무실', 'SMS');

  final String name;
  final String key;
  const RoleType(this.name, this.key);
}