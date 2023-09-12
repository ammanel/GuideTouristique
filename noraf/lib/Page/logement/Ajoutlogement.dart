import 'dart:io';

import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashtoast/flash_toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Model/Images.dart';
import '../../Model/logement.dart';
import '../../Repository/AuthentificationService.dart';
import '../../Repository/ImagesRepository.dart';
import '../../Repository/logementRepository.dart';
import '../Acceuil.dart';
import '../utils/getImage.dart';

import '../../Model/logement.dart';
import '../utils/getImage.dart';

class LogementForm extends StatefulWidget {
  @override
  _LogementFormState createState() => _LogementFormState();
}

class _LogementFormState extends State<LogementForm> {
  final _formKey = GlobalKey<FormState>();
  File imageselected = File("");
  bool statutimage = false;
  String _uid = '';
  String _idLogement = '';
  String _image = '';
  String _description = '';
  String _titre = '';
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _prix = '';
  double latitude = 0;
  double longitude = 0;

  String _coordonnees = '';
  String _statut = '';
  var stateValue = null;
  var cityValue = null;
  var countryValue = null;
  logementRepository logementrep = new logementRepository();

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  String? localite = "";
  List<Placemark>? placemark;
  void getAddress()async{
    placemark = await placemarkFromCoordinates(latitude, longitude);
    print(placemark?[0].street);
    setState(() {
      localite = placemark?[0].street;
    });
    print("Nom : ${placemark?[0].administrativeArea}");
    FlashToast.showFlashToast(context: context, title: "Succes", message: "Votre emplacement à été sélectionné avec succes", flashType: FlashType.success,flashPosition: FlashPosition.top);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text('Ajouter un logement'),

        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                statutimage
                    ? InkWell(onTap: () async {
                  selectImage();
                }, child: Container(
                    width: 250,
                    height: 250,
                    child: Image.file(imageselected, fit: BoxFit.cover,)))
                    : ElevatedButton(onPressed: () async {
                  selectImage();
                }, child: Container(
                    width: 250,
                    height: 250,
                    child: Center(child: Icon(Icons.add,size: 40,)))),

                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(5.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    prefixIcon: Icon(Icons.message),
                    hintText: "Décrivez votre appartement",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],

                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer une description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    prefixIcon: Icon(Icons.home),
                    hintText: "Donnez un titre à votre appartement",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],


                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un titre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _titre = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                TextFormField(
                  decoration: InputDecoration(

                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(5.5)
                    ),
                    prefixIcon: Icon(Icons.monetization_on),
                    hintText: "Prix de la location journalière",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],


                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Veuillez entrer un prix';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _prix = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // showDialog(context: context, builder: (builder){
                        //   return Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // });
                        _determinePosition().then((value){
                          // Navigator.pop(context);

                          print('${value.latitude}');
                          print('${value.longitude}');

                          setState(() {
                            latitude = value.latitude;
                            longitude = value.longitude;
                          });
                          getAddress();
                          print("Coordonnées");
                        });
                      },

                      child: Container(
                        width: MediaQuery.of(context).size.width/6,
                          child: Icon(Icons.location_on_outlined)),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(

                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(5.5)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(5.5)
                          ),

                          hintText: "${localite}",
                          hintStyle: TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey[100],
                          enabled: false


                        ),
                        
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () {
                    upload();
                  },
                  child: Text('Enregistrer'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectImage() async {
    final data = await showModalBottomSheet(context: context, builder: (ctx) {
      return GetImage();
    });

    if (data != null) {
      print("la valeure du truc trouvé est : ${data}");

      setState(() {
        imageselected = data;
        statutimage = true;
      });
    }
  }

  void upload() async {
    if(latitude == 0 || longitude ==0 )
      {
        FlashToast.showFlashToast(context: context, title: "Erreur", message: "Veillez renseigner la position de votre logement s'il vous plait", flashType: FlashType.error,flashPosition: FlashPosition.bottom);
      }else{
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        // Créez une instance de la classe Logement avec les valeurs du formulaire
        logement log = logement(
          uid: _uid,
          image: _image!,
          description: _description,
          titre: _titre,
          address: "${placemark?[0].street}-${placemark?[0].country}",
          prix: _prix,
          region: "${placemark?[0].administrativeArea}",
          options: "_options",
          coordonnees: "${latitude}+${longitude}",
          statut: "_statut",
          id_logement: _idLogement,
          id_porprietaire: _auth.currentUser!.uid,);

        print(log);
        try {
          if (statutimage == true) {

            print(_image);
            logementRepository lr = new logementRepository();
            final link = await lr.uploadImage(imageselected, path: "logement",log: log, context: context).then((
                value) {

              print("Value trouvé : $value");
            });
            _formKey.currentState!.reset();




          } else {
            FlashToast.showFlashToast(context: context, title: "Erreur", message: "Veillez renseigner une image", flashType: FlashType.error,flashPosition: FlashPosition.top);
          }
        } catch (e) {
          print(e);
        }

      }
    }


      // Utilisez l'instance de logement comme nécessaire (par exemple, l'envoyer à Firebase)

      // Réinitialisez le formulaire

    }


}