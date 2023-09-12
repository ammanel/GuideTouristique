import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../Model/Evenement.dart';
import '../../Repository/EvenementRepository.dart';
import 'package:intl/intl.dart';

import 'FormEvenement.dart';

class ListeEvenement extends StatefulWidget {
  @override
  State<ListeEvenement> createState() => _ListeEvenementState();
}

class _ListeEvenementState extends State<ListeEvenement> {
  final EvenementRepository _evenementRepository = EvenementRepository();
  Completer<GoogleMapController> _controller = Completer();
  static final DateFormat formatage = DateFormat('dd/MM/yyyy');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('liste des évènements'),
      ),
      body: StreamBuilder<List<Evenement>>(
        stream: _evenementRepository.obtenirTousLesEvenement(),
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
                            _controller.complete(controller);
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
                child: Text('Aucun produit disponible'),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text("ya problème oh fhumm!!!${snapshot.error}"),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
