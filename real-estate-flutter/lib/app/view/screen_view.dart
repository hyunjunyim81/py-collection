import 'package:flutter/material.dart';
import 'package:real_estate/search/view/search_view.dart';

class ScreenView extends StatelessWidget {
  const ScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //localizationsDelegates: AppLocalizations.localizationsDelegates,
      // localizationsDelegates: const [
      //   AppLocalizations.delegate,
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalCupertinoLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      // ],
      // supportedLocales: AppLocalizations.supportedLocales,
      // onGenerateTitle: (context) => AppLocalizations.of(context)!.app_name,
      home: Navigator(
        pages: const [
          MaterialPage(child: SearchView())
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      ),
    );
  }
}