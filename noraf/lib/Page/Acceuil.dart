import 'dart:async';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lottie/lottie.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import '../Model/Personne.dart';
import '../Model/user.dart';
import '../Repository/AuthentificationService.dart';
import '../Repository/PersonneRepository.dart';
import 'BottomNavBar/EvenementPage.dart';
import 'BottomNavBar/Reservation.dart';
import 'BottomNavBar/Settings.dart';
import 'Drawer/Drawer.dart';
import 'Reservation/ListeReservation.dart';
import 'Reservation/detailsReservation.dart';
import 'no_connexion.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({super.key});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  AuthentificationService _authentificationService = new AuthentificationService();
  PersonneRepository personneRepository = new PersonneRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool connected = false;
  String nom = "";
  int page = 0;
  TextEditingController _textEditingController = TextEditingController();
  late PageController _pageController;



  @override
  void initState(){
    _pageController = PageController();
    // TODO: implement initState
    super.initState();
    onlineuser();
    if(_auth.currentUser?.uid != null){
      setState(() {
        connected = true;
      });
    }else{
      setState(() {
        connected = false;
      });
    }
  }
  Future<Personne?> onlineuser() async{
    Personne? onlineuser= await personneRepository.readOnlineUser();
    if(onlineuser?.uid != null)
      {
        return onlineuser;
      }
    else{
      return null;
    }
  }





  bool internet = true;

  void ConnexionChecker() async{
    bool result = await InternetConnectionCheckerPlus().hasConnection;

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }
  bool loadings = false;
  @override
  Widget build(BuildContext context){
    ConnexionChecker();

    final drawercontroller = ZoomDrawerController();
    void startTimer() {
      const duration = Duration(seconds: 2);

      Timer(duration, () {
        // Code à exécuter après la durée spécifiée (5 secondes)
        setState(() {
          loadings = false;
        });
      });
    };

    startTimer();
    return internet == true?Scaffold(

      /*appBar: AppBar(
        title: page==0?Text("Home"):page==5?Text("Recherche"):page==1?Text("Reservation"):page==2?Text("Setting"):Text(""),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> Recherche()));

          }, child: Icon(Icons.search))
        ],
      ),*/
      body: loadings==true?Center(child: Container(
          width: MediaQuery.of(context).size.width/2,

          child: Lottie.asset("lib/assets/IJK8ydzR2E.json")),):ZoomDrawer(

        showShadow: true,
        style: DrawerStyle.defaultStyle,
        menuBackgroundColor: Colors.grey,
        menuScreen: CustumDrawer(drawercontroller),
        mainScreen: FutureBuilder(future: onlineuser(),
            builder: (context,snapshot){

              if(page == 0){
                return ReservationClass();
              }else if(page == 1){
                return EvenementPage();
              }else if(page == 2){
                return listeReservation();
              }else if(page == 3){
                return Settings();
              }
              return Center(child: Text("User off-line"),);
            }

        ),
        controller: drawercontroller,

      ),

        bottomNavigationBar: BottomNavyBar(
          selectedIndex: page,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            page = index;
            if(_pageController.hasClients){
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 200), curve: Curves.ease);
            }

          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Acceuil'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.map),
                title: Text('Evènements'),
                activeColor: Colors.red
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.bed),
                title: Text('Reservation'),
                activeColor: Colors.red
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.red
            ),
          ],
        )
    ) : Scaffold(
      body: no_connexion(),
    );
  }
}


