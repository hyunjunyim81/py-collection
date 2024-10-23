import 'package:flutter/material.dart';
import 'package:real_estate/api/net_api.dart';
import 'package:real_estate/common/di/extension_get_it.dart';
import 'package:real_estate/repo/estate_repo.dart';
import 'package:real_estate/search/model/thing.dart';

class InfoItemView extends StatelessWidget {
  late final EstateRepo estateRepo = di.inject();
  Thing thing;

  InfoItemView({super.key, required this.thing});

  @override
  Widget build(BuildContext context) {
    return
      GestureDetector(
          onTap: () async {
            await NetAPI.launchInBrowser(estateRepo.filter!, thing);
          },
          child: Container(
            color: Colors.white,
            height: 102,
            child: Column(
              children: [
                Container(height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(bottom: 10),
                ),
                SizedBox(height: 20, child: _firstColumn(),),
                SizedBox(height: 20, child: _secondColumn(),),
                SizedBox(height: 20, child: _thirdColumn(),),
                SizedBox(height: 20, child: _fourthColumn(),),
                //SizedBox(height: 20,),
                //SizedBox(height: 20,),
                Container(height: 1,
                  color: Colors.grey,
                  margin: const EdgeInsets.only(top: 10),
                ),
              ],
            ),
          )
      );
  }

  Widget _firstColumn() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(thing.atclNm,
              style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(thing.priceDesc(),
              style: const TextStyle(fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue)),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          margin: const EdgeInsets.only(bottom: 2),
          child: Text('${thing.flrInfo}층  ${thing.spaceSquare()}(${thing.spaceKor()})',
              style: const TextStyle(fontSize: 14, color: Colors.black)),
        ),
      ],
    );
  }

  Widget _secondColumn() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(thing.atclFetrDesc,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14,
                  color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _thirdColumn() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(thing.tags(),
              style: const TextStyle(fontSize: 14,
                  backgroundColor : Colors.black12,
                  color: Colors.black)),
        ),
      ],
    );
  }

  Widget _fourthColumn() {
    return Row(
      children: [
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(thing.atclCfmYmd,
              style: const TextStyle(fontSize: 14,
                  color: Colors.redAccent)),
        ),
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Text(thing.cpNm.isNotEmpty
              ? '${thing.cpNm} | ${thing.rltrNm}' : thing.rltrNm,
              style: const TextStyle(fontSize: 14,
                  color: Colors.black)),
        ),
      ],
    );
  }
}