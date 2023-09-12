import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:glass/glass.dart';
import 'package:lottie/lottie.dart';

import 'package:read_more_text/read_more_text.dart';

import '../../Model/SiteTouristique.dart';
import '../../Model/logement.dart';
import '../../Repository/PersonneRepository.dart';
import '../../Repository/SiteTouristiqueRepository.dart';
import '../../Repository/logementRepository.dart';
import '../../Repository/produit_repository.dart';
import '../Produit/PageListeProduit.dart';
import '../Recherche.dart';
import '../Site/FormSiteTouristique.dart';
import '../Site/detailsSite.dart';
import '../logement/Ajoutlogement.dart';
import '../logement/detailslogement.dart';
import '../utils/CustumText.dart';
import 'Settings.dart';


class ReservationClass extends StatefulWidget {
  const ReservationClass({super.key});


  @override
  State<ReservationClass> createState() => _ReservationClassState();
}

class _ReservationClassState extends State<ReservationClass> with TickerProviderStateMixin{
  late TabController _controller ;
  late final AnimationController _controllerlikeanimation;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _controller = new TabController(length: 3, vsync: this);
    _controllerlikeanimation = new AnimationController(
        duration: Duration(seconds: 2),
        vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controllerlikeanimation.dispose();
    _scrollController.dispose();
  }

  bool likebutton = false;




  @override
  Widget build(BuildContext context) {
    final SiteTouristiqueRepository _siteTouristiqueRepository =
    SiteTouristiqueRepository();
    FirebaseAuth _auth = FirebaseAuth.instance;
    PersonneRepository pr= new PersonneRepository();
    logementRepository lr = new logementRepository();
    final page = MediaQuery.of(context);
    bool lmogement = true;
    bool sites = false;
    bool produits = false;
    ProduitRepository produitRepository = ProduitRepository();
    PersonneRepository _personneRep = new PersonneRepository();
    SiteTouristiqueRepository siteTouristiqueRepository = new SiteTouristiqueRepository();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Container(

              child: Column(
                  children: [

                    SizedBox(
                      height: 10,
                    ),
                    //text ,icon et image


                    //Boutton de recherche
                    Container(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Recherche()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0,3)
                            )],
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey[100]
                          ),
                          width: page.size.width/1.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(width: 20,),
                              Icon(CupertinoIcons.search,size: 20,),
                              SizedBox(width: 20,),
                              Text("Rechercher un logement..."),
                              Expanded(child: Container())



                            ],
                          ),

                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    //Serachbar

                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustumText("Trouvez la destination \nde vos rêves",Colors.black,"Acme",30),
                        ),
                      ],
                    ),*/
                    //Tap bar
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(

                      ),
                      width: double.infinity,
                      child: TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.black,
                        controller: _controller,
                        indicator: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: Colors.black
                                )
                            ),
                        ),
                        tabs: [
                          Tab(text: "Logements"),
                          Tab(text: "Sites",),
                            Tab(text: "Produits",),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    Container(

                      height: page.size.height/1.42,
                      width: page.size.width/1.05,

                      child: TabBarView(
                        controller: _controller,
                        children: [

                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                FutureBuilder(future: pr.readOnlineUser(),
                                    builder: (context,snapshot){
                                      return StreamBuilder<List<logement>>(

                                        stream: lr.readAlllogement(),
                                        builder: (context,snapshot){
                                          /*showDialog(context: context, builder: (context){
                                            return Center(child: CircularProgressIndicator(),);
                                          });*/
                                          if(snapshot.hasError){
                                            print(snapshot.error);
                                            return Center(child: Text("Une erreur s'est produite...",));
                                          }
                                          else if(snapshot.hasData){
                                            final logements = snapshot.data!;
                                            return logements.isEmpty ? Center(child: Text("Aucun enregistrement trouvé"),) :

                                            Expanded(
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap:(){
                                                      if(_auth.currentUser != null) {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => LogementForm()));
                                                      }else{
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context) => Settings()));

                                                      }
                                                    },
                                                    child: Center(
                                                      child: Container(
                                                        decoration: BoxDecoration(

                                                            boxShadow: [BoxShadow(
                                                                color: Colors.grey.withOpacity(0.5),
                                                                spreadRadius: 0,
                                                                blurRadius: 5,
                                                                offset: Offset(0,3)
                                                            )],
                                                            borderRadius: BorderRadius.circular(10),
                                                            color: Colors.grey[100]
                                                        ),
                                                        width: MediaQuery.of(context).size.width/1.15,
                                                        height: MediaQuery.of(context).size.height/6,
                                                        child: Row(

                                                          children: [
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            Container(
                                                              width: MediaQuery.of(context).size.width/2.2,
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: [
                                                                  Wrap(
                                                                    children: [
                                                                      CustumText("Mettez votre logement sur NORAF", Colors.black, "Acme", 20)
                                                                    ],
                                                                  ),

                                                                  Wrap(
                                                                    children: [
                                                                      Text("Commencez votre activité et gagnez de l'argent en toute simplicité")
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),

                                                            Container(
                                                              child: Lottie.asset("lib/assets/home_animated_icon.json",width: 150),
                                                            )
                                                          ],
                                                        ),

                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),


                                                  Expanded(
                                                    child: ListView.builder(

                                                      controller: _scrollController,
                                                      itemCount: logements.length,
                                                        itemBuilder: (BuildContext context, int index) {
                                                          return InkWell(
                                                              onTap: (){

                                                                Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementDetailsPage(logent: logements[index])));


                                                              },
                                                              child: Column(
                                                                children: [

                                                                  Stack(
                                                                    children: [
                                                                      Card(
                                                                        elevation: 0,
                                                                        shadowColor: Colors.black,

                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(Radius.circular(0))
                                                                        ),

                                                                        child: Column(
                                                                          children: [
                                                                            Card(

                                                                              shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.all(Radius.circular(15))
                                                                              ),
                                                                              child: CachedNetworkImage(
                                                                                imageUrl: "${logements[index].image}",
                                                                                imageBuilder: (context,imageprovider){
                                                                                  return Container(
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                      image: DecorationImage(
                                                                                          image:
                                                                                          imageprovider,fit: BoxFit.cover),
                                                                                    ),

                                                                                    //Propriétés de l'image
                                                                                    width: page.size.width,
                                                                                    height: page.size.height/2.2,
                                                                                  );
                                                                                },
                                                                                placeholder: (context,url) => Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                                  ),

                                                                                  //Propriétés de l'image
                                                                                  width: page.size.width,
                                                                                  height: 160,

                                                                                ).asGlass(),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Wrap(
                                                                                        children: [
                                                                                          Container(
                                                                                              width: 200,
                                                                                              child: Text("${logements[index].titre}",style: TextStyle(fontSize: 15,fontFamily: "Schyler"),)),
                                                                                        ],
                                                                                      ),

                                                                                      Text("${snapshot.data?[index].prix} XOF",style: TextStyle(fontFamily: "Acme"),)
                                                                                    ],
                                                                                  ),
                                                                                  Column(
                                                                                    children: [

                                                                                      Container(
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Icon(CupertinoIcons.star_fill,size: 12,),
                                                                                            Text("4,95")
                                                                                          ],
                                                                                        ),
                                                                                      )

                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),

                                                                          ],
                                                                        ),
                                                                      ),

                                                                      //bOUTTON LIKE
                                                                      Positioned(
                                                                          right: 0,
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(20.0),
                                                                            child: Container(
                                                                                width: 30,
                                                                                height: 30,
                                                                                child: GestureDetector(
                                                                                  onTap: (){
                                                                                    if(likebutton == false){
                                                                                      likebutton = true;
                                                                                      _controllerlikeanimation.forward();
                                                                                    }else{
                                                                                      likebutton = false;
                                                                                      _controllerlikeanimation.reverse();
                                                                                    }
                                                                                  },
                                                                                  child: Lottie.asset("lib/assets/Heart.json",controller: _controllerlikeanimation).asGlass(
                                                                                    clipBorderRadius: BorderRadius.circular(8.0),
                                                                                  ),
                                                                                )),
                                                                          )),

                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            );

                                                        },

                                                      ),
                                                  ),
                                                ],
                                              ),
                                            );

                                          }else{
                                            return Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: page.size.width/1.09,
                                                  height: page.size.height/3,

                                                ).asGlass(),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: page.size.width/3,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color:Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: page.size.width/4,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color:Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Column(
                                                children: [
                                                Container(
                                                decoration: BoxDecoration(
                                          color:Colors.grey[200],
                                          borderRadius: BorderRadius.circular(15)
                                          ),
                                          width: page.size.width/1.09,
                                          height: page.size.height/5.5,

                                          ).asGlass(),
                                          SizedBox(
                                          height: 5,
                                          ),
                                          Container(
                                          width: page.size.width/3,
                                          height: 20,
                                          decoration: BoxDecoration(
                                          color:Colors.grey[200],
                                          borderRadius: BorderRadius.circular(15)
                                          ),
                                          ),
                                          SizedBox(
                                          height: 5,
                                          ),
                                          Container(
                                          width: page.size.width/4,
                                          height: 20,
                                          decoration: BoxDecoration(
                                          color:Colors.grey[200],
                                          borderRadius: BorderRadius.circular(15)
                                          ),
                                          ),
                                          SizedBox(
                                          height: 10,
                                          ),

                                          ],
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          )
                                              ],
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                            );
                                          }
                                        },
                                      );

                                    }),


                              ],
                            ),
                          ),


                          Container(
                            
                            child: Column(

                              children: [
                                FutureBuilder(future: pr.readOnlineUser(),
                                    builder: (context,snapshot){
                                      return StreamBuilder<List<SiteTouristique>>(

                                        stream: siteTouristiqueRepository.obtenirTousLesSites(),
                                        builder: (context,snapshot){
                                          /*showDialog(context: context, builder: (context){
                                            return Center(child: CircularProgressIndicator(),);
                                          });*/
                                          if(snapshot.hasError){
                                            print(snapshot.error);
                                            return Center(child: Text("Une erreur s'est produite...",));
                                          }
                                          else if(snapshot.hasData){
                                            final siteTouristiqueRepository = snapshot.data!;
                                            return siteTouristiqueRepository.isEmpty ? Center(child: Text("Aucun enregistrement trouvé"),) :

                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: siteTouristiqueRepository.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  return InkWell(
                                                    onTap: (){
                                                      print("Site touché");
                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> detailsSite(logent: snapshot.data![index])));
                                                    },
                                                    child: Stack(
                                                      children: [
                                                        Card(
                                                          elevation: 0,
                                                          shadowColor: Colors.black,

                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(Radius.circular(0))
                                                          ),

                                                          child: Column(
                                                            children: [
                                                              Card(

                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                                                ),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: "${siteTouristiqueRepository[index].image}",
                                                                  imageBuilder: (context,imageprovider){
                                                                    return Container(
                                                                      decoration: BoxDecoration(
                                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                        image: DecorationImage(
                                                                            image:
                                                                            imageprovider,fit: BoxFit.cover),
                                                                      ),

                                                                      //Propriétés de l'image
                                                                      width: page.size.width,
                                                                      height: 300,
                                                                    );
                                                                  },
                                                                  placeholder: (context,url) => Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: page.size.width,
                                                                    height: 160,

                                                                  ).asGlass(),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Wrap(
                                                                          children: [
                                                                            Container(
                                                                                width: 200,
                                                                                child: Text("${siteTouristiqueRepository[index].nom}",style: TextStyle(fontSize: 15,fontFamily: "Schyler"),)),
                                                                          ],
                                                                        ),

                                                                        Text("${snapshot.data?[index].region} ",style: TextStyle(fontFamily: "Acme"),)
                                                                      ],
                                                                    ),
                                                                    Column(
                                                                      children: [

                                                                        Container(
                                                                          child: Row(
                                                                            children: [
                                                                              Icon(CupertinoIcons.star_fill,size: 12,),
                                                                              Text("4,95")
                                                                            ],
                                                                          ),
                                                                        )

                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),

                                                            ],
                                                          ),
                                                        ),

                                                        Positioned(
                                                            right: 0,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Container(
                                                                  width: 30,
                                                                  height: 30,
                                                                  child: GestureDetector(
                                                                    onTap: (){
                                                                      if(likebutton == false){
                                                                        likebutton = true;
                                                                        _controllerlikeanimation.forward();
                                                                      }else{
                                                                        likebutton = false;
                                                                        _controllerlikeanimation.reverse();
                                                                      }
                                                                    },
                                                                    child: Lottie.asset("lib/assets/Heart.json",controller: _controllerlikeanimation).asGlass(
                                                                      clipBorderRadius: BorderRadius.circular(8.0),
                                                                    ),
                                                                  )),
                                                            )),

                                                      ],
                                                    ),
                                                  );

                                                },

                                              ),
                                            );

                                          }else{
                                            return Column(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color:Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                  width: page.size.width/1.09,
                                                  height: page.size.height/3,

                                                ).asGlass(),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: page.size.width/3,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color:Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Container(
                                                  width: page.size.width/4,
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                      color:Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(15)
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      );

                                    }),
                              ],
                            ),
                          ),
                          PageListeProduit(),
                        ],
                      ),
                    )
                  ],
                ),

            ),
          ),
        ),
      ),
    )




    /*FutureBuilder(future: pr.readOnlineUser(),
      builder: (context,snapshot){
        return StreamBuilder<List<logement>>(

          stream: lr.readAlllogement(),
          builder: (context,snapshot){
            if(snapshot.hasError){
              print(snapshot.error);
              return Center(child: Text("Une erreur s'est produite...",));
            }
            else if(snapshot.hasData){
              final logements = snapshot.data!;
              return logements.isEmpty ? Center(child: Text("Aucun enregistrement trouvé"),) : ListView.builder(
                itemCount: logements.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Card(
                            elevation: 3,

                            child: Container(
                              width: MediaQuery.of(context).size.width*0.9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(

                                    children: [
                                      Icon(Icons.image,size: 150,)
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${logements[index].titre}"),
                                      Text("${logements[index].region}"),
                                      Text("${logements[index].address}"),
                                      SizedBox(height: 30,),
                                      Text("${logements[index].prix} FCFA")
                                    ],
                                  ),
                                  Column(

                                    children: [
                                      Icon(CupertinoIcons.suit_heart_fill,color: Colors.red,),
                                      SizedBox(
                                        height: 55,
                                      ),

                                      Icon(Icons.star,size: 15,color: CupertinoColors.activeOrange,),
                                      SizedBox(
                                        width: 80,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),

                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementDetailsPage(logent: logements[index])));
                            print("Touché container numero : "+index.toString());

                          },
                        )
                      ],
                    ),
                  );
                },

              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        );

      })*/;


  }
}




/*//Container titre du site
                                    Container(
                                      height: 50,

                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(15),
                                            child: CustumText("Titre du site", Colors.black, "Acme", 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Image
                                    CachedNetworkImage(
                                      imageUrl: "https://cdn.pixabay.com/photo/2021/04/11/19/26/africa-6170631_1280.jpg",
                                      imageBuilder: (context,imageprovider){
                                        return Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image:
                                                imageprovider,fit: BoxFit.cover),
                                          ),

                                          //Propriétés de l'image
                                          height: MediaQuery.of(context).size.height/2,

                                        );
                                      },
                                      placeholder: (context,url) => Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(15)),
                                        ),

                                        //Propriétés de l'image
                                        width: MediaQuery.of(context).size.width/2,
                                        height: 160,

                                      ).asGlass(),
                                    ),
                                    Container(


                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(CupertinoIcons.heart,size: 30,),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Icon(Icons.message,size: 30,),
                                                SizedBox(
                                                  width: 15,
                                                ),
                                                Icon(Icons.send,size: 30,),
                                                Expanded(child: Container()),
                                                Icon(Icons.more_horiz,size: 30,),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(


                                              child: Wrap(
                                                children: [
                                                  ReadMoreText("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                                                      , numLines: 3, readMoreText: "plus", readLessText: "moins")
                                                  ],
                                              ),
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(labelText: 'Ajouter un commentaire'),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Veuillez entrer un commetaire';
                                                }
                                                return null;
                                              },

                                              onSaved: (value) {

                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),*/
