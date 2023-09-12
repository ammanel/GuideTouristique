import 'dart:io';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../Model/Evenement.dart';
import '../../Repository/EvenementRepository.dart';

class FormEvement extends StatefulWidget {
  final Evenement evenement;
  FormEvement({required this.evenement});

  @override
  State<FormEvement> createState() => _FormEvementState();
}

class _FormEvementState extends State<FormEvement> {
  final EvenementRepository _evenementRepository = EvenementRepository();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _oldImageUrl;
  DateTime date_debut = DateTime.now();
  DateTime date_fin = DateTime.now();
  bool _locationButtonClicked = false;
  Position positionCourante = Position(
    latitude: 0.0,
    longitude: 0.0,
    timestamp: DateTime.now(),
    accuracy: 0.0,
    altitude: 100.0,
    heading: 0.0,
    speed: 0.0,
    speedAccuracy: 0.0,
  );

  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  //méthode pour l'ajout d'image

  @override
  void initState() {
    super.initState();
    _oldImageUrl = widget.evenement.image;
    _nomController.text = widget.evenement.nom;
    _descriptionController.text = widget.evenement.description;
    _regionController.text = widget.evenement.region;
    date_debut = widget.evenement.date_debut;
    date_fin = widget.evenement.date_fin;
  }

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

  Future<void> _getCurrentLocation() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          positionCourante = position;
        });
      } catch (e) {
        print(e);
      }
    } else {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ajouter un evenement'),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the GlobalKey to the Form
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
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
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
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Date de debut',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      date_debut = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
                DateTimeFormField(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'Date de fin',
                  ),
                  mode: DateTimeFieldPickerMode.date,
                  autovalidateMode: AutovalidateMode.always,
                  validator: (e) =>
                  (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                  onDateSelected: (DateTime value) {
                    setState(() {
                      date_fin = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                  width: 20,
                ),
               StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _locationButtonClicked = true;
                        });
                        _getCurrentLocation();
                      },
                      child: Text(
                        'Enregistrer votre position actuelle comme lieu de l\'événement',
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
			                    if (_locationButtonClicked == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Enregistrer votre position GPS'),
                        ),
                      );
                    } else {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedImage != null || _oldImageUrl != null) {
                        final evenement = Evenement(
                          id_evenement: widget.evenement.id_evenement,
                          image: _selectedImage != null ? '' : _oldImageUrl!,
                          nom: _nomController.text,
                          region: _regionController.text,
                          description: _descriptionController.text,
                          date_debut: date_debut,
                          date_fin: date_fin,
                          coordonnees: LatLng(positionCourante.latitude,
                              positionCourante.longitude),
                          statut: true,
                        );

                        if (widget.evenement.id_evenement.isNotEmpty) {
                          _evenementRepository
                              .mettreAJourEvenement(evenement, _selectedImage)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                Text('Evenement mis à jour avec succès'),
                              ),
                            );
                          }).catchError((error) {
                            // Afficher un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de la mise à jour de l\' Evenement',
                                ),
                              ),
                            );
                          });
                        } else {
                          // Ajouter un nouveau produit
                          _evenementRepository
                              .ajouterEvenement(evenement, _selectedImage!,
                              context: context)
                              .then((_) {
                            // Réinitialiser les champs et l'image sélectionnée
                            setState(() {
                              _selectedImage = null;
                              _nomController.clear();
                              _regionController.clear();
                              _descriptionController.clear();
                            });

                            // Afficher un message de succès
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Evenement ajouté avec succès'),
                              ),
                            );
                          }).catchError((error) {
                            // Afficher un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de l\'ajout de l\'Evenement',
                                ),
                              ),
                            );
                          });
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
                    }
                  },
                  child: Text(
                    widget.evenement.id_evenement.isNotEmpty
                        ? 'Mettre à jour'
                        : 'Ajouter',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
