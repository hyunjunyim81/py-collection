import 'package:flutter/material.dart';

import '../di/extension_get_it.dart';
import '../di/inject_method.dart';
import '../di/inject_scope.dart';

abstract class PageState<T extends StatefulWidget> extends State<T> with InjectMethod {

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: body(context)
      ),
    );
  }

  Widget body(BuildContext context);

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