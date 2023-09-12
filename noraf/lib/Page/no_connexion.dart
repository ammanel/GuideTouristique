import 'package:flutter/material.dart';
class no_connexion extends StatelessWidget {
  const no_connexion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.signal_wifi_connected_no_internet_4,size: 100),
          Text("Aucune connexion internet")
        ],
      ),),
    );
  }
}
