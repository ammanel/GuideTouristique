import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glass/glass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Model/Images.dart';
import '../../Model/logement.dart';
import '../../Repository/AuthentificationService.dart';
import '../../Repository/ImagesRepository.dart';
import '../../Repository/logementRepository.dart';
import '../Acceuil.dart';
import '../BottomNavBar/Settings.dart';
import '../Reservation/ReservationAjout.dart';
import '../utils/CustumText.dart';
import '../utils/getImage.dart';


class LogementDetailsPage extends StatefulWidget {
  final logement logent;
  File imageselected = File("");
  bool statutimage = false;
  LogementDetailsPage({required this.logent});



  @override
  _LogementDetailsState createState() => _LogementDetailsState();

}

  class _LogementDetailsState extends State<LogementDetailsPage>{


    @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

@override
  Widget build(BuildContext context) {

  double latitude = double.parse(this.widget.logent.coordonnees.split("+")[0]);
  double longitude = double.parse(this.widget.logent.coordonnees.split("+")[1]);

  List<Marker> _marker = [];
  ImageConfiguration config = createLocalImageConfiguration(context);
  List<Marker> _list = [
    Marker(
        position: LatLng(latitude, longitude),

        markerId: MarkerId("1")),
  ];
  _marker.addAll(_list);
    ImagesRepository ir = new ImagesRepository();
    logementRepository lr = new logementRepository();
    FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
     
      body: Container(
        child: Container(
              height: MediaQuery.of(context).size.height,

              child: Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: "${this.widget.logent.image}",
                    imageBuilder: (context,imageprovider){
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          image: DecorationImage(
                              image:
                              imageprovider,fit: BoxFit.cover),
                        ),

                        //Propriétés de l'image
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/2,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: SafeArea(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                InkWell(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        width: 60,
                                        height: 50,
                                        child: Icon(CupertinoIcons.back,size: 40,color: Colors.white,)).asGlass(

                                      clipBorderRadius: BorderRadius.circular(15.0),
                                    )),
                                SizedBox(
                                ),
                                Container(
                                    height: 50,
                                    width: 60,
                                    child: Center(child: Icon(Icons.favorite,size: 40,color: Colors.white,))).asGlass(
                                  clipBorderRadius: BorderRadius.circular(15.0),
                                )
                              ],
                            ),
                          ),
                        ),
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
                  Expanded(child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                          children: [
                            //Image

                            Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Container(

                                child: Column(
                                  children: [
                                    //Nom du logement et le rate
                                    Row(
                                      children: [
                                        Container(
                                          width : MediaQuery.of(context).size.width/1.5,
                                          child: Wrap(
                                            children: [
                                              CustumText("${this.widget.logent.titre}", Colors.black, "Acme", 25),
                                            ],
                                          ),
                                        ),
                                        Expanded(child: Container()),
                                        Icon(Icons.star,size: 20,color: Colors.lightBlue,),
                                        Text("4.8",style: TextStyle(color: Colors.grey[500]),)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //position
                                    Row(
                                      children: [
                                        Icon(Icons.location_on,color: Colors.lightBlue),
                                        CustumText("${this.widget.logent.address}", Colors.grey, "Acme", 20),
                                        Expanded(child: Container()),

                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Description
                                    Row(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/1.2,
                                          child: Text("${this.widget.logent.description}",style: TextStyle(color: Colors.grey,fontFamily: "Acme"),),
                                        )

                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    //Listes des images
                                    Row(
                                      children: [
                                        CustumText("Plus d'images", Colors.black, "Acme", 20),
                                        Expanded(child: Container())
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    StreamBuilder<List<Images>>(
                                        stream: ir.readUserAllImages(this.widget.logent.uid) ,

                                        builder: (context,snapshot){
                                          if(snapshot.hasError){
                                            print("Un erreur est survenu");
                                          }else{
                                            if(snapshot.hasData){
                                              print(snapshot.data);
                                              print("Donnée trouvée");
                                              final image = snapshot.data!;
                                              return snapshot.data!.isEmpty?Text("Aucune images disponible pour ce logements"):Container(
                                                height: MediaQuery.of(context).size.height/6,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: image.length,
                                                    itemBuilder: (BuildContext context,int index){

                                                      return Padding(
                                                        padding: const EdgeInsets.all(0.0),
                                                        child: Container(

                                                          child: image[index].Image_1=="Image_1"?image[index].Image_2=="Image_2"?image[index].Image_3=="Image_3"?image[index].Image_4=="Image_4"?Container(
                                                            width: MediaQuery.of(context).size.width/1.2,

                                                            child: Wrap(

                                                              children: [
                                                                Text("Aucunes autres photo disponible pour ce logement",style: TextStyle(fontFamily: "Acme",fontSize: 18,color: Colors.grey),)
                                                              ],
                                                            ),
                                                          ):Row(
                                                            children: [
                                                              image[index].Image_1=="Image_1"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_1}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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


                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_2=="Image_2"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_2}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_3=="Image_3"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_3}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_4=="Image_4"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_4}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                            ],
                                                          ):Row(
                                                            children: [
                                                              image[index].Image_1=="Image_1"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_1}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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


                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_2=="Image_2"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_2}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_3=="Image_3"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_3}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_4=="Image_4"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_4}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                            ],
                                                          ):Row(
                                                            children: [
                                                              image[index].Image_1=="Image_1"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_1}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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


                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_2=="Image_2"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_2}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_3=="Image_3"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_3}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_4=="Image_4"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_4}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                            ],
                                                          ):Row(
                                                            children: [
                                                              image[index].Image_1=="Image_1"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_1}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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


                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_2=="Image_2"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_2}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_3=="Image_3"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_3}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                              image[index].Image_4=="Image_4"?Container() :CachedNetworkImage(
                                                                imageUrl: "${image[index].Image_4}",
                                                                imageBuilder: (context,imageprovider){
                                                                  return Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.all(Radius.circular(15)),
                                                                      image: DecorationImage(
                                                                          image:
                                                                          imageprovider,fit: BoxFit.cover),
                                                                    ),

                                                                    //Propriétés de l'image
                                                                    width: MediaQuery.of(context).size.width/2,
                                                                    height: 160,
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
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              );
                                            }else{
                                              print('Aucune donnée trouvé');
                                              return CircularProgressIndicator();

                                            }
                                          }
                                          return Text("LE SNAPSHOT");
                                        }),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Column(
                                      children: [
                                        Container(

                                          width: MediaQuery.of(context).size.width,
                                          height: 300,
                                          child: GoogleMap(
                                            markers: Set<Marker>.of(_marker),
                                              initialCameraPosition: CameraPosition(target: LatLng(latitude,longitude),zoom: 15)),
                                        ),
                                      ],
                                    )
                                    
                                  ],

                                ),

                              ),
                            )
                            
                          ],
                        ),
                    ),

                  )),

                  Container(

                    height: 80,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("${this.widget.logent.prix} FCFA\n/Jours",style: TextStyle(fontFamily: "Acme",fontSize: 20),),

                          TextButton(onPressed: (){
                            if(_auth.currentUser!= null){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ReservationForm(log: this.widget.logent)));
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> Settings()));
                            }
                          }, child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.lightBlue,
                            ),

                            width: MediaQuery.of(context).size.width/2,
                            child: Center(child: CustumText("Reserver", Colors.white, "Acme", 25)),
                          ))
                        ],
                      ),
                    ),
                  ),
                ],
              )

            ),

      ),
    );

  }

void selectImage(logement log) async {
  final data = await showModalBottomSheet(context: context, builder: (ctx) {
    return GetImage();
  });

  if (data != null) {
    print("la valeure du truc trouvé est : ${data}");

    setState(() {
      this.widget.imageselected = data;
      this.widget.statutimage = true;
    });
    logementRepository lr = new logementRepository();
    showModalBottomSheet(context: context, builder: (context){
      return Center(
        child: CircularProgressIndicator(),
      );
    });
    lr.updateImage(this.widget.imageselected, path: "logement", log: this.widget.logent, context: context, type: 'image');
    print("Update effectué");
  }
}







}

/*
StreamBuilder<List<Images>>(
stream: ir.readUserAllImages(this.widget.logent.uid) ,

builder: (context,snapshot){
if(snapshot.hasError){
print("Un erreur est survenu");
}else{
if(snapshot.hasData){
print(snapshot.data);
print("Donnée trouvée");
final image = snapshot.data!;
return snapshot.data!.isEmpty?Text("Aucune images dispo pour ce logements"):Container(
height: MediaQuery.of(context).size.height/10,
child: ListView.builder(
scrollDirection: Axis.horizontal,
itemCount: image.length,
itemBuilder: (BuildContext context,int index){

return Padding(
padding: const EdgeInsets.all(8.0),
child: Row(
children: [
Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(0)),
image: DecorationImage(
image: NetworkImage(image[index].Image_1),fit: BoxFit.cover
),
),
height: MediaQuery.of(context).size.height/12,
width: MediaQuery.of(context).size.width/5,
),
SizedBox(
width: 15,
),
Container(
height: MediaQuery.of(context).size.height/12,
width: MediaQuery.of(context).size.width/5,
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(0)),
image: DecorationImage(
image: NetworkImage(image[index].Image_2),fit: BoxFit.cover
),
),
),
SizedBox(
width: 15,
),
Container(
height: MediaQuery.of(context).size.height/12,
width: MediaQuery.of(context).size.width/5,
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(0)),
image: DecorationImage(
image: NetworkImage(image[index].Image_3),fit: BoxFit.cover
),
),
),
SizedBox(
width: 15,
),
Container(
height: MediaQuery.of(context).size.height/12,
width: MediaQuery.of(context).size.width/5,
decoration: BoxDecoration(
borderRadius: BorderRadius.all(Radius.circular(0)),
image: DecorationImage(
image: NetworkImage(image[index].Image_4),fit: BoxFit.cover
),
),
),
],
),
);
}),
);
}else{
print('Aucune donnée trouvé');
return CircularProgressIndicator();

}
}
return Text("LE SNAPSHOT");
}),*/