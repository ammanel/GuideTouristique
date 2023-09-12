import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/ImageSite.dart';
import '../../Repository/ImageSiteRepository.dart';
import 'ListeSiteTouristique.dart';


class PageImageSite extends StatefulWidget {
  final String id_site_touristique;

  PageImageSite({required this.id_site_touristique});

  @override
  _PageImageSiteState createState() => _PageImageSiteState();
}

class _PageImageSiteState extends State<PageImageSite> {
  final ImageSiteRepository _imageSiteRepository = ImageSiteRepository();
  List<File?> imageFiles = [null, null, null, null];

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectImage(int index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        if (index < imageFiles.length) {
          imageFiles[index] = file;
        } else {
          imageFiles.add(file);
        }
      });
    }
  }

  void _redirection() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListeSiteTouristique()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sélection d\'image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFiles[0] != null
                      ? Image.file(
                          imageFiles[0]!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                SizedBox(width: 36), // Espace entre les boutons
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFiles[1] != null
                      ? Image.file(
                          imageFiles[1]!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: 36), // Espace entre les rangées de boutons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFiles[2] != null
                      ? Image.file(
                          imageFiles[2]!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                SizedBox(width: 36), // Espace entre les boutons
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: imageFiles[3] != null
                      ? Image.file(
                          imageFiles[3]!,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(
                height: 24), // Espace entre les boutons et les autres éléments

            ElevatedButton(
              onPressed: () => _selectImage(0),
              child: Text('Image 1'),
            ),

            ElevatedButton(
              onPressed: () => _selectImage(1),
              child: Text('Image 2'),
            ),

            ElevatedButton(
              onPressed: () => _selectImage(2),
              child: Text('Image 3'),
            ),

            ElevatedButton(
              onPressed: () => _selectImage(3),
              child: Text('Image 4'),
            ),

            ElevatedButton(
              onPressed: () {
                List<File> nonNullListe = imageFiles
                    .where((file) => file != null)
                    .map((file) => file!)
                    .toList();
                final imagesiteEntite = ImageSite(
                  id_image_site: '',
                  id_site_touristique: widget.id_site_touristique,
                  image1: imageFiles[0]?.path ?? '',
                  image2: imageFiles[1]?.path ?? '',
                  image3: imageFiles[2]?.path ?? '',
                  image4: imageFiles[3]?.path ?? '',
                );
                if (nonNullListe.isNotEmpty) {
                  _imageSiteRepository.ajouterimageSite(imagesiteEntite,
                      nonNullListe, widget.id_site_touristique);
                  _redirection();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Choisissez au moins une image avant d\'enregistrer.'),
                    ),
                  );
                }
              },
              child: Text('Enregistrer'),
            ),

            ElevatedButton(
              onPressed: _redirection,
              child: Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
