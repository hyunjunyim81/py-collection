import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate/app/scope/app_scopes.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/common/di/inject_scope.dart';
import 'package:real_estate/common/view/page_state.dart';
import 'package:real_estate/model/estate_model.dart';
import 'package:real_estate/search/view/village_view.dart';

import 'info_list_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<StatefulWidget> createState() => _SearchViewState();
}


class _SearchViewState extends PageState<SearchView> {

  @override
  Widget body(BuildContext context) {
    return const Column(
      children: [
        SizedBox(
          height: 50,
          child: VillageView(),
        ),
        Expanded(
            child: InfoListView(),
        ),
      ],
    );
  }

  @override
  List<IScope> scopes() => [estateScope];
}