import 'package:flutter/material.dart';

class DialogForm {
  bool _isDismiss = false;
  late DialogRoute route;

  void dismiss() {
    _isDismiss = true;
  }

  Future<void> _untilDismissCheck(BuildContext context) async {
    Future.doWhile(() async {
      if (_isDismiss) {
        Navigator.of(context).removeRoute(route);
        return false;
      }
      await Future.delayed(
        const Duration(milliseconds: 100), () => {},
      );
      return true;
    });
  }

  DialogForm showProgress(BuildContext context) {
    route = generateDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _untilDismissCheck(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          ),
          backgroundColor: Colors.white10,
          content: const SizedBox(
            height: 50,
            child: Center(
                child: SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                      strokeWidth: 5.0
                  ),
                )
            ),
          ),
        );
      },
    );
    return this;
  }

  DialogForm showPopup({required BuildContext context,
    required String title,
    required String message,
    required String closeText,
    required Function? pressed,
    String? extendText,
    Function? extendEvent,}) {
    route = generateDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _untilDismissCheck(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          ),
          title: Text(title),
          content: SingleChildScrollView(child: Text(message)),
          actions: <Widget>[
            if (extendText?.isNotEmpty ?? false)
              TextButton(
                child: Text(extendText!),
                onPressed: () {
                  extendEvent?.call();
                  dismiss();
                },
              ),
            TextButton(
              child: Text(closeText),
              onPressed: () {
                pressed?.call();
                dismiss();
              },
            ),
          ],
        );
      },
    );
    return this;
  }

  static DialogRoute generateDialog({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
    TraversalEdgeBehavior? traversalEdgeBehavior,
  }) {

    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(
        context,
        rootNavigator: useRootNavigator,
      ).context,
    );

    var dialogRoute = DialogRoute(
      context: context,
      builder: builder,
      barrierColor: barrierColor ?? Colors.black54,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      settings: routeSettings,
      themes: themes,
      anchorPoint: anchorPoint,
      traversalEdgeBehavior: traversalEdgeBehavior ?? TraversalEdgeBehavior.closedLoop,
    );

    Navigator.of(context, rootNavigator: useRootNavigator).push(dialogRoute);
    return dialogRoute;
  }
}