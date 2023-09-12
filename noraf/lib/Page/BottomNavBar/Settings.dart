import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';


import '../../Model/Personne.dart';
import '../../Model/Produit.dart';
import '../../Repository/AuthentificationService.dart';
import '../../Repository/PersonneRepository.dart';
import '../Abonnement/AbonnementActif.dart';
import '../Abonnement/MonAbonnement.dart';
import '../Acceuil.dart';
import '../Admin/SiteAdmin/ListeSiteAdmin.dart';
import '../Evenement/MesEvenements.dart';
import '../Evenement/stories/LesStories.dart';
import '../Form.dart';
import '../Personne/editpersonne.dart';
import '../Produit/Mesproduits.dart';
import '../Produit/Produit.dart';
import '../connexion.dart';
import '../logement/Meslogements.dart';
import '../utils/CustumText.dart';
class Settings extends StatefulWidget {


  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Personne personne = new Personne(role: "user", uid: "uid", id_user: "id_user", nom: "nom", prenom: "prenom", address: "address", numero_telephone: "numero_telephone", email: "email", motdepass: "motdepass", sexe: "sexe", date_naissance: "date_naissance", statutpaiement: false, fin_abonnement: DateTime.now());
  @override
  Widget build(BuildContext context) {
    PersonneRepository pr  = new PersonneRepository();
    FirebaseAuth _auth = FirebaseAuth.instance;
    PersonneRepository pp = new PersonneRepository();
    return _auth.currentUser != null?Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("Profile",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            ]
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,

            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width/1.25,
                  height: MediaQuery.of(context).size.height/4,
                  decoration: BoxDecoration(
                      boxShadow: [BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 5,
                          offset: Offset(0,3)
                      )],
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.grey[100]
                  ),
                  child: Container(
                    child: Container(
                      child: Column(
                        children: [

                          Container(
                            width: 200,
                            height: 150,
                            child: Lottie.asset("lib/assets/122225-profile-avatar-of-young-boy (1).json"),
                          ),
                          FutureBuilder(
                              future: pp.readOnlineUser(),
                              builder: (context,snapshot){
                                if(snapshot.data!=null){
                                  personne = snapshot.data!;
                                  DateTime dateactuelle = DateTime.now();
                                  if(dateactuelle.isAfter(personne.fin_abonnement)){

                                    pp.FinAbonnement(personne.uid);

                                  }else{

                                  }
                                }
                                return snapshot.data != null? CustumText("${snapshot.data!.nom}", Colors.black, "Acme", 25) : Text("Chargement");
                              }),
                          personne.role == "user"?Column(
                            children: [
                              Text("${_auth.currentUser!.email}",style: TextStyle(fontSize: 15,fontFamily: "Acme"),),
                              Text("${personne.statutpaiement?"Fin abonnement : ${DateFormat.MMMMEEEEd().format(personne.fin_abonnement)}":"Abonnement inactif"}")
                            ],
                          ):Container()
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Expanded(child:
                Container(

                  child:
                  Container(
                    width: MediaQuery.of(context).size.width/1.1,

                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Paramètres",style: TextStyle(fontSize: 20),),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Colors.grey
                                )
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Meslogements()));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width/1.35,
                                  height: 50,

                                  child: Row(

                                    children: [
                                      Container(
                                          width : 50,


                                          child: Icon(CupertinoIcons.home)),
                                      Container(
                                          width: MediaQuery.of(context).size.width/1.8,

                                          child: Text("Mes logements"))
                                    ],
                                  ),

                                ),
                              ),
                              Container(
                                width: 30,
                                height: 50,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(),
                                    Icon(Icons.navigate_next),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(

                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Colors.grey
                                )
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PersonneForm(personne: personne)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width/1.35,
                                  height: 50,

                                  child: Row(

                                    children: [
                                      Container(
                                          width : 50,


                                          child: Icon(CupertinoIcons.profile_circled)),
                                      Container(
                                          width: MediaQuery.of(context).size.width/1.8,

                                          child: Text("Informations personnelles"))
                                    ],
                                  ),

                                ),
                              ),
                              Container(
                                width: 30,
                                height: 50,

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(),
                                    Icon(Icons.navigate_next),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> Mesproduits(),));
                            //Pour les évenements
                          },
                            /*
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FormEvement(
                                evenement: Evenement(
                                  id_evenement: '',
                                  image: '',
                                  nom: '',
                                  region: '',
                                  coordonnees: LatLng(0.0, 0.0),
                                  description: '',
                                  date_debut: DateTime.now(),
                                  date_fin: DateTime.now(),
                                )),));
                          },*/
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey
                                  )
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/1.35,
                                  height: 50,

                                  child: Row(
                                    children: [
                                      Container(
                                          width : 50,
                                          child: Icon(Icons.fastfood)),
                                      Container(
                                          width: MediaQuery.of(context).size.width/1.8,

                                          child: Text("Mes produits"))
                                    ],
                                  ),

                                ),
                                Container(
                                  width: 30,
                                  height: 50,

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(),
                                      Icon(Icons.navigate_next),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> MesEvenement(),));
                            //Pour les évenements
                          },
                          /*
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> FormEvement(
                                evenement: Evenement(
                                  id_evenement: '',
                                  image: '',
                                  nom: '',
                                  region: '',
                                  coordonnees: LatLng(0.0, 0.0),
                                  description: '',
                                  date_debut: DateTime.now(),
                                  date_fin: DateTime.now(),
                                )),));
                          },*/
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey
                                  )
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/1.35,
                                  height: 50,

                                  child: Row(
                                    children: [
                                      Container(
                                          width : 50,
                                          child: Icon(Icons.party_mode)),
                                      Container(
                                          width: MediaQuery.of(context).size.width/1.8,

                                          child: Text("Mes Evénements"))
                                    ],
                                  ),

                                ),
                                Container(
                                  width: 30,
                                  height: 50,

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(),
                                      Icon(Icons.navigate_next),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        personne.role=="admin"?Column(
                          children: [
                          SizedBox(
                          height: 20,
                        ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> LesStories(),));
                                //Pour les évenements
                              },
                                /*
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> FormEvement(
                                    evenement: Evenement(
                                      id_evenement: '',
                                      image: '',
                                      nom: '',
                                      region: '',
                                      coordonnees: LatLng(0.0, 0.0),
                                      description: '',
                                      date_debut: DateTime.now(),
                                      date_fin: DateTime.now(),
                                    )),));
                              },*/
                              child: Container(

                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey
                                      )
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.35,
                                      height: 50,

                                      child: Row(
                                        children: [
                                          Container(
                                              width : 50,
                                              child: Icon(Icons.image_search)),
                                          Container(
                                              width: MediaQuery.of(context).size.width/1.8,

                                              child: Text("Stories"))
                                        ],
                                      ),

                                    ),
                                    Container(
                                      width: 30,
                                      height: 50,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(),
                                          Icon(Icons.navigate_next),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ): Container(),
                        personne.role =="admin"?Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> ListeSiteAdmin()));
                              },
                              child: Container(

                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey
                                      )
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.35,
                                      height: 50,

                                      child: Row(

                                        children: [
                                          Container(
                                              width : 50,


                                              child: Icon(Icons.maps_home_work_outlined)),
                                          Container(
                                              width: MediaQuery.of(context).size.width/1.8,

                                              child: Text("Sites"))
                                        ],
                                      ),

                                    ),
                                    Container(
                                      width: 30,
                                      height: 50,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(),
                                          Icon(Icons.navigate_next),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ) : Container(),


                        personne.role =="user"?Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> personne.statutpaiement?AbonnementActif():MonAbonnement()));
                              },
                              child: Container(

                                decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1,
                                          color: Colors.grey
                                      )
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width/1.35,
                                      height: 50,

                                      child: Row(

                                        children: [
                                          Container(
                                              width : 50,


                                              child: Icon(Icons.maps_home_work_outlined)),
                                          Container(
                                              width: MediaQuery.of(context).size.width/1.8,

                                              child: Text("Mon abonnement"))
                                        ],
                                      ),

                                    ),
                                    Container(
                                      width: 30,
                                      height: 50,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          SizedBox(),
                                          Icon(Icons.navigate_next),
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ) : Container(),

                        SizedBox(
                          height: 20,
                        ),

                        //Container log out
                        GestureDetector(
                          onTap: (){
                            AuthentificationService _auth = new AuthentificationService();
                            _auth.signOut();
                            _auth.SignoutWithGoogle();
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));
                          },
                          child: Container(

                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey
                                  )
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width/1.35,
                                  height: 50,

                                  child: Row(

                                    children: [
                                      Container(
                                          width : 50,


                                          child: Icon(Icons.login_outlined,color: Colors.red,)),
                                      Container(
                                          width: MediaQuery.of(context).size.width/1.8,

                                          child: Text("Se deconnecter",style: TextStyle(color: Colors.red),))
                                    ],
                                  ),

                                ),
                                Container(
                                  width: 30,
                                  height: 50,

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(),
                                      Icon(Icons.navigate_next),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(child: Container(

                          child: Center(child: Text("Powered by Noraf Technologie",style: TextStyle(color: Colors.grey),)),
                        ))

                      ],
                    ),
                  )

                  /*Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.add_home_outlined,color: Color(0xff55ba5b),)),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Meslogements()));
                            },
                            child: CustumText("Mes logements", Colors.black, "Acme", 20)),
                        SizedBox(
                          width: 67,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[300],
                            ),

                            child: Icon(Icons.navigate_next,color: Colors.grey,))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.wallet,color: Color(0xff55ba5b),)),
                        SizedBox(
                          width: 10,
                        ),
                        CustumText("Portefeuille", Colors.black, "Acme", 20),
                        SizedBox(
                          width: 94,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[300],
                            ),

                            child: Icon(Icons.navigate_next,color: Colors.grey,))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.label_important_outline,color: Color(0xff55ba5b),)),
                        SizedBox(
                          width: 10,
                        ),
                        CustumText("Bientôt disponible", Colors.black, "Acme", 20),
                        SizedBox(
                          width: 42,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[300],
                            ),

                            child: Icon(Icons.navigate_next,color: Colors.grey,))
                      ],
                    ),
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        CircleAvatar(
                            backgroundColor: Colors.green[100],
                            child: Icon(Icons.info_outline_rounded,color: Color(0xff55ba5b),)),
                        SizedBox(
                          width: 10,
                        ),
                        CustumText("Information", Colors.black, "Acme", 20),
                        SizedBox(
                          width: 90,
                        ),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[300],
                            ),

                            child: Icon(Icons.navigate_next,color: Colors.grey,))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () {
                        AuthentificationService _auth = new AuthentificationService();
                        _auth.signOut();
                        _auth.SignoutWithGoogle();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          CircleAvatar(
                              backgroundColor: Colors.green[100],
                              child: Icon(Icons.login_outlined,color: Color(0xff55ba5b),)),
                          SizedBox(
                            width: 10,
                          ),
                          CustumText("logout", Colors.red, "Acme", 20),
                          SizedBox(
                            width: 135,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[300],
                            ),

                              child: Icon(Icons.navigate_next,color: Colors.grey,))
                        ],
                      ),
                    ),
                  ],
                )*/,
                ))
              ],
            ),
          ),
        ),
      ),
    ): Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Container(
                  width: 250,
                  child: Lottie.asset("lib/assets/63004-profile-password-unlock.json"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/8,
                ),
                CustumText("Rejoignez nous", Colors.black, "Acme", 40),
                SizedBox(
                  height: MediaQuery.of(context).size.height/25,
                ),
                Container(

                  width: MediaQuery.of(context).size.width/1.5,

                    child: Text("Connectez vous et accédez à la totalité des fonctionnalités de NORAF")),
                SizedBox(
                  height: MediaQuery.of(context).size.height/15,
                ),

                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginForm()));

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    width: MediaQuery.of(context).size.width/1.5,
                    height: 50,

                    child: Center(child: Text("Se connecter",style: TextStyle(color: Colors.white),)),
                  ),
                ),

                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UserForm()));

                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width/1.5,
                    height: 50,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 0.5
                        ),
                        right: BorderSide(
                            color: Colors.black,
                            width: 0.5
                        ),
                        left: BorderSide(
                            color: Colors.black,
                            width: 0.5
                        ),
                        top: BorderSide(
                            color: Colors.black,
                            width: 0.5
                        ),
                      )
                    ),
                    child: Center(child: Text("S'inscrire",style: TextStyle(color: Colors.black),)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*
TextButton(onPressed: (){
AuthentificationService _auth = new AuthentificationService();
_auth.signOut();
_auth.SignoutWithGoogle();
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));
}, child: Text("logout"))
*/
