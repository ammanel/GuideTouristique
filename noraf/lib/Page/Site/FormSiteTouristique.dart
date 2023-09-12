import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';


import '../../Model/SiteTouristique.dart';
import '../../Repository/SiteTouristiqueRepository.dart';

class FormSiteTouristique extends StatefulWidget {
  final SiteTouristique site;
  FormSiteTouristique({required this.site});
  @override
  State<FormSiteTouristique> createState() => FormSiteTouristiqueState();
}

class FormSiteTouristiqueState extends State<FormSiteTouristique> {
  final SiteTouristiqueRepository _siteRepository = SiteTouristiqueRepository();
  final TextEditingController _histoireController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _localiteController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  String? _oldImageUrl;
  String id = "";
  final _formKey = GlobalKey<FormState>(); // Added form key

  @override
  void initState() {
    super.initState();
    _oldImageUrl = widget.site.image;
    _histoireController.text = widget.site.histoire;
    _nomController.text = widget.site.nom;
    _localiteController.text = widget.site.localite;
    _descriptionController.text = widget.site.description;
    _regionController.text = widget.site.region;
    _latitudeController.text = widget.site.coordonnees.latitude.toString();
    _longitudeController.text = widget.site.coordonnees.longitude.toString();
  }

  File? _selectedImage;

  // Method for selecting an image
   Future<void> _selectImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return;

    if (pickedImage.path != '' && pickedImage.path.isNotEmpty) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    } else if (_oldImageUrl != null) {
      setState(() {
        _selectedImage = File(_oldImageUrl!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Site touristique'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            // Added Form widget
            key: _formKey, // Assigned form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_selectedImage != null) Image.file(_selectedImage!),
                ElevatedButton(
                  onPressed: _selectImage,
                  child: Text('Sélectionner une image'),
                ),
                TextFormField(
                  controller: _nomController,
                  decoration: InputDecoration(labelText: 'Nom'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _histoireController,
                  decoration: InputDecoration(labelText: 'histoire'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(labelText: 'latitude'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(labelText: 'longitude'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _localiteController.text.isEmpty
                      ? null
                      : _localiteController.text,
                  onChanged: (String? newValue) {
                    setState(() {
                      _localiteController.text = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'lome',
                      child: Text('lome'),
                    ),
                    DropdownMenuItem(
                      value: 'kara',
                      child: Text('kara'),
                    ),
                    DropdownMenuItem(
                      value: 'kpalime',
                      child: Text('kpalime'),
                    ),
                    DropdownMenuItem(
                      value: 'sokode',
                      child: Text('sokode'),
                    ),
                    DropdownMenuItem(
                      value: 'atakpame',
                      child: Text('atakpame'),
                    ),
                    DropdownMenuItem(
                      value: 'tsevie',
                      child: Text('tsevie'),
                    ),
                    DropdownMenuItem(
                      value: 'aneho',
                      child: Text('aneho'),
                    ),
                    DropdownMenuItem(
                      value: 'mango',
                      child: Text('mango'),
                    ),
                    DropdownMenuItem(
                      value: 'dapaong',
                      child: Text('dapaong'),
                    ),
                    DropdownMenuItem(
                      value: 'notse',
                      child: Text('notse'),
                    ),
                    DropdownMenuItem(
                      value: 'tagbligbo',
                      child: Text('tagbligbo'),
                    ),
                    DropdownMenuItem(
                      value: 'vogan',
                      child: Text('vogan'),
                    ),
                  ],
                  decoration: InputDecoration(labelText: 'Localite'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _regionController.text.isEmpty
                      ? null
                      : _regionController.text,
                  onChanged: (String? newValue) {
                    setState(() {
                      _regionController.text = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'central',
                      child: Text('central'),
                    ),
                    DropdownMenuItem(
                      value: 'kara',
                      child: Text('kara'),
                    ),
                    DropdownMenuItem(
                      value: 'maritime',
                      child: Text('maritime'),
                    ),
                    DropdownMenuItem(
                      value: 'plateaux',
                      child: Text('plateaux'),
                    ),
                    DropdownMenuItem(
                      value: 'savanes',
                      child: Text('savanes'),
                    ),
                  ],
                  decoration: InputDecoration(labelText: 'Region'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedImage != null || _oldImageUrl != null) {
                        final latitude =
                            double.tryParse(_latitudeController.text);
                        final longitude =
                            double.tryParse(_longitudeController.text);
                        if (latitude != null && longitude != null) {
                          final site = SiteTouristique(
                            id_site: widget.site.id_site,
                            image: _selectedImage != null ? '' : _oldImageUrl!,
                            nom: _nomController.text,
                            description: _descriptionController.text,
                            histoire: _histoireController.text,
                            localite: _localiteController.text,
                            region: _regionController.text,
                            coordonnees: LatLng(latitude, longitude),
                          );

                          if (widget.site.id_site.isNotEmpty) {
                            _siteRepository
                                .mettreAJourSite(site, _selectedImage)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Site mis à jour avec succès'),
                                ),
                              );
                            }).catchError((error) {
                              // Afficher un message d'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erreur lors de la mise à jour du site'),
                                ),
                              );
                            });
                          } else {
                            // Ajouter un nouveau produit
                            _siteRepository
                                .ajouterSite(site, _selectedImage!,
                                    context: context)
                                .then((_) {
                              // Réinitialiser les champs et l'image sélectionnée
                              setState(() {
                                _selectedImage = null;
                                _nomController.clear();
                                _descriptionController.clear();
                                _histoireController.clear();
                                _localiteController.clear();
                                _regionController.clear();
                                _longitudeController.clear();
                                _latitudeController.clear();
                              });

                              // Afficher un message de succès
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('site ajouté avec succès')),
                              );
                            }).catchError((error, stackTrace) {
                              // Afficher l'erreur détaillée
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erreur lors de la sauvegarde du site: ${error.toString()}'),
                                ),
                              );
                            });
                          }
                        } else {
                          // Afficher un message d'erreur si les valeurs de latitude et de longitude ne sont pas numériques
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Veuillez entrer des valeurs de latitude et de longitude valides'),
                            ),
                          );
                        }
                      } else {
                        // Afficher un message d'erreur si aucune image n'est sélectionnée
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Veuillez sélectionner une image'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(widget.site.id_site.isNotEmpty
                      ? 'Mettre à jour'
                      : 'Ajouter'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
