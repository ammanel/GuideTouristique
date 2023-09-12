import 'package:flutter/material.dart';

import '../utils/CustumText.dart';
class CustumDrawer extends StatelessWidget {
  final zoomdrawercontroller;
  CustumDrawer(this.zoomdrawercontroller);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Container(

          child: SafeArea(
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height/3,
                ),
                //Image de l'application
                Container(
                  width: 150,
                  child: Image.asset("lib/assets/Fichier 2.png"),
                ),
                CustumText("Version 1.0", Colors.white, "Acme", 25),
                //Boutton paramètre
                

                SizedBox(
                  height: 100,
                ),

                CustumText("A venire...", Colors.white, "Acme", 25)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
