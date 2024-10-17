abstract class IScope {
  final bool isSingleton;
  final String name;
  IScope({this.isSingleton = false, this.name = ''});
}

final uniScope = _UniScope();

class _UniScope extends IScope {
  _UniScope({super.isSingleton = true, super.name = 'UniScope'});
}