import 'package:flutter/material.dart';

import 'extension_get_it.dart';
import 'inject_method.dart';
import 'inject_scope.dart';

abstract class InjectState<T extends StatefulWidget> extends State<T> with InjectMethod {

  @override
  void initState() {
    inject();
    super.initState();
  }

  @override
  void dispose() {
    deject();
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      di.resetIfZero();
    });
  }

  @override
  List<IScope> scopes();

  @override
  void inject() {
    for(var scope in scopes()) {
        di.reference(scope);
    }
  }

  @override
  void deject() {
    for(var scope in scopes()) {
      di.deference(scope);
    }
  }
}