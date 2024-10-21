import 'package:flutter/material.dart';
import 'package:real_estate/model/view/thing.dart';

class InfoItemView extends StatelessWidget {
  Thing thing;

  InfoItemView({super.key, required this.thing});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 102,
      child: Column(
        children: [
          Container(height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(bottom: 10),
          ),
          SizedBox(height: 20, child: _firstColumn(),),
          SizedBox(height: 20, child: _secondColumn(),),
          SizedBox(height: 20, child: _thirdColumn(),),
          SizedBox(height: 20, child: _fourthColumn(),),
          //SizedBox(height: 20,),
          //SizedBox(height: 20,),
          Container(height: 1,
            color: Colors.grey,
            margin: EdgeInsets.only(top: 10),
          ),
        ],
      ),
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
          margin: const EdgeInsets.only(top: 2),
          child: Text('${thing.rletTpNm} ${thing.flrInfo}층',
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
              style: const TextStyle(fontSize: 14,
                  color: Colors.black38)),
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
          child: Text('${thing.cpNm} | ${thing.rltrNm}',
              style: const TextStyle(fontSize: 14,
                  color: Colors.black)),
        ),
      ],
    );
  }
}