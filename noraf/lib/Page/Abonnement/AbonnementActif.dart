import 'package:flutter/material.dart';
class AbonnementActif extends StatelessWidget {
  const AbonnementActif({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A B O N N E M E N T"),
        centerTitle: true,
      ),
      body: Center(
        child: Text("Votre abonnement est actif"),
      ),
    );
  }
}
