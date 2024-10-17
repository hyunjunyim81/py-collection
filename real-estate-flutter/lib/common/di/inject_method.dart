import 'inject_scope.dart';

abstract class InjectMethod {
  List<IScope> scopes();

  void inject();

  void deject();
}