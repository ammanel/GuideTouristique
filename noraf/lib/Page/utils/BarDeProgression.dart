import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';
class ProgressBar extends StatelessWidget {

  double percent = 0;
  ProgressBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      minHeight: 15,
      value: percent,
      backgroundColor: Colors.white,
      color: Colors.red,
    );

  }
}
