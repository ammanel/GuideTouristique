import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

import '../../Model/SiteTouristique.dart';
import '../../Repository/SiteTouristiqueRepository.dart';
import 'FormSiteTouristique.dart';

class ListeSiteTouristique extends StatefulWidget {
  @override
  _ListeSiteTouristiqueState createState() => _ListeSiteTouristiqueState();
}

class _ListeSiteTouristiqueState extends State<ListeSiteTouristique> {
  final SiteTouristiqueRepository _siteTouristiqueRepository =
      SiteTouristiqueRepository();
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des sites'),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SiteTouristique>>(
        stream: _siteTouristiqueRepository.obtenirTousLesSites(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sites = snapshot.data!;
            if (sites != null && sites.isNotEmpty) {
              return ListView.builder(
                itemCount: sites.length,
                itemBuilder: (context, index) {
                  final site = sites[index];
                  final marker = Marker(
                    markerId: MarkerId(site.id_site.toString()),
                    position: LatLng(
                        site.coordonnees.latitude, site.coordonnees.longitude),
                    infoWindow: InfoWindow(
                      title: site.nom,
                      snippet: site.region,
                    ),
                  );
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20,bottom: 20),
                            child: ListTile(
                              leading: Image.network(site.image),
                              title: Text(site.nom),
                              subtitle: Text(site.region),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              FormSiteTouristique(site: site),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _siteTouristiqueRepository
                                          .supprimerSite(site.id_site);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      /*Container(
                        height: 200,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(site.coordonnees.latitude,
                                site.coordonnees.longitude),
                            zoom: 50,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          markers: Set<Marker>.from([marker]),
                        ),
                      ),*/
                    ],
                  );
                },
              );
            } else {
              return Center(
                child: Text('Aucun Site disponible'),
              );
            }
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
