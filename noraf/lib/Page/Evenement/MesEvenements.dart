import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Model/Evenement.dart';
import '../../Repository/EvenementRepository.dart';
import 'package:intl/intl.dart';

import 'FormEvenement.dart';

class MesEvenement extends StatefulWidget {
  @override
  State<MesEvenement> createState() => _MesEvenementState();
}

class _MesEvenementState extends State<MesEvenement> {
  final EvenementRepository _evenementRepository = EvenementRepository();
  Completer<GoogleMapController> _controller = Completer();
  static final DateFormat formatage = DateFormat('dd/MM/yyyy');
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text('E V E N N E M E N T'),
        elevation: 0,
        centerTitle: true,
      ),
      body: StreamBuilder<List<Evenement>>(
        stream: _evenementRepository.obtenirTousMesEvenement(_auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final evenements = snapshot.data!;
            if (evenements.isNotEmpty) {
              return ListView.builder(
                itemCount: evenements.length,
                itemBuilder: (context, index) {
                  final evenement = evenements[index];
                  final marker = Marker(
                    markerId: MarkerId(evenement.id_evenement.toString()),
                    position: LatLng(evenement.coordonnees.latitude,
                        evenement.coordonnees.longitude),
                    infoWindow: InfoWindow(
                        title: evenement.nom, snippet: evenement.region),
                  );
                  String dateDebut = formatage.format(evenement.date_debut);
                  String dateFin = formatage.format(evenement.date_fin);
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.network(evenement.image),
                        title: Text(evenement.nom),
                        subtitle:
                        Text('date debut: $dateDebut | date fin: $dateFin'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            FormEvement(evenement: evenement)),
                                  );
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  _evenementRepository.supprimerEvenement(
                                      evenement.id_evenement);
                                },
                                icon: Icon(Icons.delete)),
                          ],
                        ),
                      ),
                      Container(
                        height: 200,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(evenement.coordonnees.latitude,
                                evenement.coordonnees.longitude),
                            zoom: 50,
                          ),
                          onMapCreated: (GoogleMapController controller) {

                            try {
                              _controller.complete(controller);
                            } on Exception catch (e) {
                              // TODO
                              print(e);
                            }
                          },
                          markers: Set<Marker>.from([marker]),
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: Text("Vous n'avez encore ajouté aucun évènement"),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Container(
                width: 270,
                  child: Text("Une erreure est survenue, vérifiez votre connexion internet ou réessayez plus tard")),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> FormEvement(evenement: Evenement(id_evenement: "", image: "", nom: "", region: "", coordonnees: LatLng(0,0), description: "", date_debut: DateTime.now(), date_fin: DateTime.now()),)));
      },
        child: Icon(Icons.add),
      ),
    );
  }
}
