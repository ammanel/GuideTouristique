import 'package:flutter/material.dart';

import '../../Model/Evenement.dart';
class Story extends StatelessWidget {

  final Evenement? event;
  Story({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.orangeAccent,
            shape: BoxShape.circle,
        ),
        height: 50,
        width: 70,

      child: Padding(
        padding: const EdgeInsets.all(1.9),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage("${event!.image}")
              )
            ),
            ),
      ),
      ),);
  }
}
