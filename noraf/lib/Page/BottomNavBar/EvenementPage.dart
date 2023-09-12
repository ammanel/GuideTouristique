import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';


import '../../Model/Evenement.dart';
import '../../Repository/EvenementRepository.dart';
import '../Evenement/FormEvenement.dart';
import '../Evenement/PageStorie.dart';
import '../logement/Ajoutlogement.dart';
import '../logement/detailslogement.dart';
import '../utils/CustumText.dart';
import '../utils/story.dart';
import 'Settings.dart';
class EvenementPage extends StatefulWidget {
  const EvenementPage({super.key});

  @override
  State<EvenementPage> createState() => _EvenementPageState();
}

class _EvenementPageState extends State<EvenementPage> with TickerProviderStateMixin{

  EvenementRepository er = new EvenementRepository();
  late final AnimationController _controllerlikeanimation;

   _ouvrirlastorie(Evenement? event){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PageStorie(event: event,)));
  }
  FirebaseAuth _auth = FirebaseAuth.instance;

   @override
   void initState() {
    // TODO: implement initState
    super.initState();
    _controllerlikeanimation = new AnimationController(
        duration: Duration(seconds: 2),
        vsync: this);
  }

  bool likebutton = false;
  @override
  Widget build(BuildContext context) {
    final page = MediaQuery.of(context);
    return Scaffold(
      
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<List<Evenement>>(
              stream: er.obtenirtouteslesstories(),
              builder: (context,snapshot){
                if(snapshot.hasData) {
                  return Column(
                    children: [
                      snapshot.data!.isEmpty ? Container() : SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            if (snapshot.hasError) {
                              print(snapshot.error);
                            }
                            return GestureDetector(
                              onTap: () {
                                print("toucher");
                                _ouvrirlastorie(snapshot.data?[index]);
                              },
                              child: Story(
                                event: snapshot.data != null ? snapshot
                                    .data![index] : Evenement(
                                    id_evenement: "id_evenement",
                                    image: "https://cdn.pixabay.com/photo/2017/01/28/02/24/japan-2014618_1280.jpg",
                                    nom: "nom",
                                    region: "region",
                                    coordonnees: LatLng(10, 15),
                                    description: "description",
                                    date_debut: DateTime.now(),
                                    date_fin: DateTime.now()),
                              ),
                            );
                          },),
                      ),


                    ],
                  );
                }else{
                  return Container();
                }
              },
            ),
    StreamBuilder<List<Evenement>>(
    stream: er.obtenirTousLesEvenement(),
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
      print("toucher");
    if(_auth.currentUser != null) {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => LogementForm()));
    }else{
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => Settings()));

    }
    },
    child: Center(
    child: GestureDetector(
        onTap: (){

          if(_auth.currentUser!=null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                FormEvement(evenement: Evenement(id_evenement: "",
                    image: "",
                    nom: "",
                    region: "",
                    coordonnees: LatLng(0, 0),
                    description: "",
                    date_debut: DateTime.now(),
                    date_fin: DateTime.now()))));
          }else{
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                Settings()));
          }
          },
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
        CustumText("Ajoutez un évènement sur NORAF", Colors.black, "Acme", 20)
        ],
        ),

        Wrap(
        children: [
        Text("Faites part aux autres des évènements que vous organisez")
        ],
        ),
        ],
        ),
        ),

        Container(
        child: Lottie.asset("lib/assets/29774-dance-party.json",width: 150),
        )
        ],
        ),

        ),
    ),
    ),
    ),
    SizedBox(
    height: 10,
    ),


    Expanded(
    child: ListView.builder(

    itemCount: logements.length,
    itemBuilder: (BuildContext context, int index) {
    return InkWell(
    onTap: (){
      print("toucher");

    //Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (context)=> LogementDetailsPage(logent: logements[index])));


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
    child: Text("${logements[index].nom}",style: TextStyle(fontSize: 15,fontFamily: "Schyler"),)),
    ],
    ),

    Text("${snapshot.data?[index].region}",style: TextStyle(fontFamily: "Acme"),)
    ],
    ),
    Column(
    children: [

    Container(
    child: Row(
    children: [

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
    )
          ],
        ),
      )
    );
  }
}
/*
,*/
