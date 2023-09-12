import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Model/SiteTouristique.dart';
import '../../../Repository/SiteTouristiqueRepository.dart';
import '../../Site/FormSiteTouristique.dart';
class ListeSiteAdmin extends StatefulWidget {
  const ListeSiteAdmin({super.key});

  @override
  State<ListeSiteAdmin> createState() => _ListeSiteAdminState();
}

class _ListeSiteAdminState extends State<ListeSiteAdmin> {
  final SiteTouristiqueRepository _siteTouristiqueRepository =
  SiteTouristiqueRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des sites',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: StreamBuilder<List<SiteTouristique>>(
        stream: _siteTouristiqueRepository.obtenirTousLesSites(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final sites = snapshot.data!;
            if (sites != null && sites.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView.builder(
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
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              color: Colors.grey[200],
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
                  ),
                ),
              );
            } else {
              return Center(
                child: Text("Vous n'avez encore ajouté aucun Site"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> FormSiteTouristique(site: SiteTouristique(id_site: "", nom: "", description: "", histoire: "", localite: "", region: "", image: "", coordonnees: LatLng(0,0)),)));
          
        },
      ),
    );
  }
}
