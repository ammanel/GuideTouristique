import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../Acceuil.dart';

class chargementpage extends StatefulWidget {
  bool loading = true;

  @override
  State<chargementpage> createState() => _chargementpageState();
}



class _chargementpageState extends State<chargementpage> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(
      vsync: this,duration: const Duration(seconds: 2))..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);


  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return this.widget.loading?Scaffold(
      body: Center(
        child: Container(

            width: MediaQuery.of(context).size.width/2,

            child: FadeTransition(
              opacity: _animation,
              child: Container(

                  child: Image.asset("lib/assets/Fichier 3.png",width: 10)),
            )
        ),
      ),
    ):MaterialApp(
      home: Acceuil(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.red),
      ),
    );
  }

  void startTimer() {
    const duration = Duration(seconds: 8);

    Timer(duration, () {
      // Code à exécuter après la durée spécifiée (5 secondes)
      setState(() {
        this.widget.loading = false;
      });
    });
  }
}
