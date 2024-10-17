import 'extension_get_it.dart';

class InjectorExample {
  late final _InjectObject _injectObject = di.inject();
}

class _InjectObject {
  _InjectObject() {
    //
  }
}

void _getItRegister() {
  di.registerSingleton(_InjectObject());
}