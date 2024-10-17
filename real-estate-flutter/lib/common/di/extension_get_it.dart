import 'dart:math';

import 'package:get_it/get_it.dart';
import 'inject_scope.dart';

GetIt di = GetIt.instance;

class _ScopeRef {
  int count = 0;
  final _ObjectPool pool = _ObjectPool();
  _ScopeRef();

  void increase() => ++count;

  void decrease() {
    count = max(count - 1, 0);
  }
}

class _ObjectPool {
  final Map<String, dynamic> _objPool = <String, dynamic>{};

  T get<T extends Object>() {
    var name = T.runtimeType.toString();
    try {
      return _objPool[name] as T;
    }
    catch (e) {
      //
    }

    var ret = di.get<T>();
    _objPool[name] = ret;
    return ret;
  }
}

extension ExtensionGetIt on GetIt {
  static final Map<String, _ScopeRef> _scopeRefMap = <String, _ScopeRef>{};
  static const bool isDebug = false;

  void scopeClear() {
    _scopeRefMap.clear();
  }

  void reference(IScope scope) {
    if (scope.isSingleton) {
      return;
    }

    try {
      var scopeRef = _scopeRefMap[scope.name];
      scopeRef!.increase();
      if (isDebug) print('reference key : ${scope.name} / ${scopeRef.count}');
      return;
    }
    catch (e) {
      //
    }

    var scopeRef = _ScopeRef();
    _scopeRefMap.putIfAbsent(scope.name, () => scopeRef);
    scopeRef.increase();
    if (isDebug) print('reference key : ${scope.name} / ${scopeRef.count}');
  }

  void deference(IScope scope) {
    if (scope.isSingleton) {
      return;
    }

    try {
      var scopeRef = _scopeRefMap[scope.name];
      scopeRef!.decrease();
      if (isDebug) print('deference key : ${scope.name} / ${scopeRef.count}');
    }
    catch (e) {
      //
    }
  }

  void resetIfZero() {
    var removeKeys = <String>[];
    for (var entry in _scopeRefMap.entries) {
      if (isDebug) print('resetIfZero key : ${entry.key} / ${entry.value.count}');
      if (entry.value.count == 0) {
        removeKeys.add(entry.key);
      }
    }

    for (var key in removeKeys) {
      _scopeRefMap.remove(key);
      if (isDebug) print('resetIfZero remove key : $key');
    }
  }

  T inject<T extends Object>({IScope? s}) {
    var scope = s ?? uniScope;
    if (scope.isSingleton) {
      return di.get<T>();
    }

    try {
      var scopeRef = _scopeRefMap[scope.name];
      return scopeRef!.pool.get<T>();
    }
    catch (e) {
      //
    }

    var scopeRef = _ScopeRef();
    _scopeRefMap.putIfAbsent(scope.name, () => scopeRef);
    return scopeRef.pool.get<T>();
  }
}