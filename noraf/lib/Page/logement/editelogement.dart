import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashtoast/flash_toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';


import '../../Model/logement.dart';
import '../../Repository/logementRepository.dart';
import '../Acceuil.dart';
import '../utils/getImage.dart';


class LogementEditPage extends StatefulWidget {
  final logement logment;

  LogementEditPage({required this.logment});

  @override
  _LogementEditPageState createState() => _LogementEditPageState();
}

class _LogementEditPageState extends State<LogementEditPage> {
  late TextEditingController _imageController;
  late TextEditingController _descriptionController;
  late TextEditingController _titreController;
  late TextEditingController _addressController;
  late TextEditingController _prixController;
  late TextEditingController _regionController;
  late TextEditingController _localiterController;
  late TextEditingController _coordonneesController;

  FirebaseAuth _auth = FirebaseAuth.instance;
  logementRepository lr = new logementRepository();
  final _formKey = GlobalKey<FormState>();

  bool statutimage = true;
  bool newimage = false;

  @override
  void initState() {
    super.initState();
    _imageController = TextEditingController(text: widget.logment.image);
    _descriptionController = TextEditingController(text: widget.logment.description);
    _titreController = TextEditingController(text: widget.logment.titre);
    _localiterController = TextEditingController(text: widget.logment.address);
    _prixController = TextEditingController(text: widget.logment.prix);
    _coordonneesController = TextEditingController(text: widget.logment.coordonnees);
    _addressController = TextEditingController(text: widget.logment.address);
    _regionController = TextEditingController(text: widget.logment.region);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titreController.dispose();
    _localiterController.dispose();
    _prixController.dispose();
    _regionController.dispose();
    _coordonneesController.dispose();
    super.dispose();
  }


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
  File imageselected = File("");

  @override
  Widget build(BuildContext context) {
    double latitude = double.parse(_coordonneesController.text.split("+")[0]);
    double longitude = double.parse(_coordonneesController.text.split("+")[1]);
    print(_coordonneesController.text);
    List<Placemark>? placemark;
    void getAddress()async{
      placemark = await placemarkFromCoordinates(latitude, longitude);
      print(placemark?[0].street);
      print(_coordonneesController.text);
      setState(() {
        localite = placemark?[0].street;
        _coordonneesController.text = "$latitude+$longitude";
      });
      if(placemark!=null){
        setState(() {
          _localiterController.text = placemark![0].street!;

        });
      }
      print("Nom : ${placemark?[0].administrativeArea}");
      FlashToast.showFlashToast(context: context, title: "Succes", message: "Votre emplacement à été sélectionné avec succes", flashType: FlashType.success,flashPosition: FlashPosition.top);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le Logement',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
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
                          child: newimage?Container(
                              width: 150,
                              height: 150,
                              child: Image.file(this.imageselected,fit: BoxFit.cover,)):
                          Container(
                              width: 150,
                              height: 150,
                              child: Image.network(_imageController.text, fit: BoxFit.cover,))))
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
                        controller: _descriptionController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer une description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _descriptionController.text = value!;
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
                        controller: _titreController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer un titre';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _titreController.text = value!;
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
                        controller: _prixController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer un prix';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _prixController.text = value!;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(context: context, builder: (builder){
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              });
                              _determinePosition().then((value){
                                Navigator.pop(context);

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
                              controller: _localiterController,
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



                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {

                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  // Créer une nouvelle instance de Logement avec les modifications
                  logement modifiedLogement = logement(
                    uid: widget.logment.uid,
                    id_logement: this.widget.logment.uid,
                    image: _imageController.text,
                    description: _descriptionController.text,
                    titre: _titreController.text,
                    address: "${_localiterController.text}",
                    prix: _prixController.text,
                    region: "${placemark?[0].administrativeArea}",
                    options: this.widget.logment.options,
                    coordonnees: "${_coordonneesController.text}",
                    statut: "statut", id_porprietaire: _auth.currentUser!.uid,
                  );

                  // Effectuer les actions nécessaires pour enregistrer les modifications
                  // par exemple, enregistrer dans une base de données Firebase
                  logementRepository lr = new logementRepository();
                  showModalBottomSheet(context: context, builder: (context){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
                  lr.Updatelogement(modifiedLogement);
                  if(newimage){
                    lr.updateImage(imageselected, path: "logement", log: this.widget.logment, context: context, type: 'logement');
                  }else{
                    print("Il s'agit de la même image");
                    Navigator.pop(context);
                    FlashToast.showFlashToast(context: context, title: "Succes", message: "Votre logement à bien été mis à jour", flashType: FlashType.success,flashPosition: FlashPosition.top);
                  }



                  // Afficher un message de réussite
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Acceuil()));
                }




              },
              child: Text('Enregistrer'),
            ),
          ],
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
        newimage = true;
      });
      print("Update effectué");
    }
  }
}
