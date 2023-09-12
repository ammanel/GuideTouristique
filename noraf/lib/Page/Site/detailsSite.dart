import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Model/ImageSite.dart';
import '../../Model/Images.dart';
import '../../Model/SiteTouristique.dart';
import '../../Repository/ImagesRepository.dart';
import '../../Repository/SiteTouristiqueRepository.dart';
import '../../Repository/logementRepository.dart';
import '../BottomNavBar/Settings.dart';
import '../Reservation/ReservationAjout.dart';
import '../utils/CustumText.dart';
import '../utils/getImage.dart';
class detailsSite extends StatefulWidget {
  final SiteTouristique logent;
  File imageselected = File("");
  bool statutimage = false;
  detailsSite({required this.logent});

  @override
  State<detailsSite> createState() => _detailsSiteState();
}

class _detailsSiteState extends State<detailsSite> {
  @override
  Widget build(BuildContext context) {

    SiteTouristiqueRepository siteTouristiqueRepository = new SiteTouristiqueRepository();
    double latitude = this.widget.logent.coordonnees.longitude;
    double longitude = this.widget.logent.coordonnees.longitude;

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
                                          CustumText("${this.widget.logent.nom}", Colors.black, "Acme", 25),
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
                                    CustumText("${this.widget.logent.localite}", Colors.grey, "Acme", 20),
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
                                StreamBuilder<List<ImageSite>>(
                                    stream: siteTouristiqueRepository.readAllSiteImage(this.widget.logent.id_site) ,

                                    builder: (context,snapshot){
                                      if(snapshot.hasError){
                                        print("Un erreur est survenu");
                                      }else{
                                        if(snapshot.hasData){
                                          print(snapshot.data);
                                          print("Donnée trouvée");
                                          final image = snapshot.data!;
                                          return snapshot.data!.isEmpty?Text("Aucune images disponible pour ce site"):Container(
                                            height: MediaQuery.of(context).size.height/6,
                                            child: ListView.builder(
                                                scrollDirection: Axis.horizontal,
                                                itemCount: image.length,
                                                itemBuilder: (BuildContext context,int index){

                                                  return Padding(
                                                    padding: const EdgeInsets.all(0.0),
                                                    child: Container(

                                                      child: image[index].image1=="Image_1"?image[index].image2=="Image_2"?image[index].image3=="Image_3"?image[index].image4=="Image_4"?Container(
                                                        width: MediaQuery.of(context).size.width/1.2,

                                                        child: Wrap(

                                                          children: [
                                                            Text("Aucunes autres photo disponible pour ce logement",style: TextStyle(fontFamily: "Acme",fontSize: 18,color: Colors.grey),)
                                                          ],
                                                        ),
                                                      ):Row(
                                                        children: [
                                                          image[index].image1=="Image_1"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image1}",
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
                                                          image[index].image2=="Image_2"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image2}",
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
                                                          image[index].image3=="Image_3"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image3}",
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
                                                          image[index].image4=="Image_4"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image4}",
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
                                                          image[index].image1=="Image_1"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image1}",
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
                                                          image[index].image2=="Image_2"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image2}",
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
                                                          image[index].image3=="Image_3"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image3}",
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
                                                          image[index].image4=="Image_4"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image4}",
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
                                                          image[index].image1=="Image_1"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image1}",
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
                                                          image[index].image2=="Image_2"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image2}",
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
                                                          image[index].image3=="Image_3"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image3}",
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
                                                          image[index].image4=="Image_4"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image4}",
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
                                                          image[index].image1=="Image_1"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image1}",
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
                                                          image[index].image2=="Image_2"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image2}",
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
                                                          image[index].image3=="Image_3"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image3}",
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
                                                          image[index].image4=="Image_4"?Container() :CachedNetworkImage(
                                                            imageUrl: "${image[index].image4}",
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

                /*Container(

                  height: 80,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("${this.widget.logent.region}",style: TextStyle(fontFamily: "Acme",fontSize: 20),),

                        TextButton(onPressed: (){
                          if(_auth.currentUser!= null){
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> ReservationForm(log: this.widget.logent)));
                          }else{
                            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Settings()));
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
                ),*/
              ],
            )

        ),

      ),
    );

  }


}
