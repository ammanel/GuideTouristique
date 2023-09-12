import 'package:flutter/material.dart';

import '../../utils/BarDeProgression.dart';

class MyStoriBar extends StatelessWidget {
  List<double> percent = [];
  MyStoriBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20,left: 8,right: 8),
      child: Row(
        children: [
          Expanded(
            child: ProgressBar(percent: percent[0],),
          ),Expanded(
            child: ProgressBar(percent: percent[1],),
          ),Expanded(
            child: ProgressBar(percent: percent[2],),
          ),
        ],
      ),
    );
  }
}
