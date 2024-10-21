const String SG_name = '상가';
const String SMS_name = '사무실';

const String SG_code = 'SG';
const String SMS_code = 'SMS';

enum RoleType
{
  SG(SG_name, 'SG'),
  SMS(SMS_name, 'SMS');

  final String name;
  final String key;
  const RoleType(this.name, this.key);
}