import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

import '../../Model/Evenement.dart';
import '../../Repository/EvenementRepository.dart';
import '../utils/BarDeProgression.dart';
class PageStorie extends StatefulWidget {
  final Evenement? event;
  PageStorie({required this.event});

  @override
  State<PageStorie> createState() => _PageStorieState();
}

class _PageStorieState extends State<PageStorie> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  final controller = StoryController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      child: StoryView(
        storyItems: [
          StoryItem.pageImage(url: this.widget.event!.image, controller: controller),
        ], controller: controller,
        inline: false,
        repeat: false,
        onComplete: (){
          Navigator.pop(context);
        },
      ),
    );
  }
  }

