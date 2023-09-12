import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lottie/lottie.dart';

import 'package:provider/provider.dart';

import '../Model/Personne.dart';
import '../Model/user.dart';
import '../Repository/AuthentificationService.dart';
import '../Repository/PersonneRepository.dart';
import 'Acceuil.dart';
import 'connexion.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});


  @override
  State<Splashscreen> createState() => _SplashscreenState();

}

class _SplashscreenState extends State<Splashscreen> {


  @override
  Widget build(BuildContext context) {


    final user = Provider.of<AppUser?>(context);
    final AuthentificationService _authService = AuthentificationService();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final userconnected = _authService;
    bool internet = true;

    void ConnexionChecker() async{
      bool result = await InternetConnectionCheckerPlus().hasConnection;
      if(result == true) {
        print('Connecté à internet');
      } else {
        print('Aucune connexion :( ');
        setState(() {
          internet = false;
        });
      }
    }

    ConnexionChecker();
    if(_auth.currentUser?.uid == null){
      print("User disconnected");
      return LoginForm();
    }else{
      print("User connected");
      final uid = _auth.currentUser!.uid;
      Personne p = new Personne(role: "role", uid: "$uid", id_user: "id_user", nom: "nom", prenom: "prenom", address: "address", numero_telephone: "numero_telephone", email: "email", motdepass: "motdepass", sexe: "sexe", date_naissance: "date_naissance", statutpaiement: false, fin_abonnement: DateTime.now());

      PersonneRepository pr = new PersonneRepository();
      return internet==true?FutureBuilder(future: pr.readOnlineUser(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){


              if(snapshot.data?.role == "admin"){
                return Scaffold(
                  appBar: new AppBar(
                    title: Text("Page Admin"),
                    actions: [ElevatedButton(onPressed: (){
                      _auth.signOut();
                    }, child: Text("log out"))],
                  ),
                );
              }if(snapshot.data?.role == "user"){
                return Acceuil();
              }

              return Center();
            }
            return Center();
          }) : Center(
        child: Icon(Icons.signal_wifi_statusbar_connected_no_internet_4),
      );
    }
  }
}
