import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../Model/Produit.dart';
import '../../Repository/produit_repository.dart';

class ProduitPage extends StatefulWidget {
  //on crée l'entité produit à manipuler
  final Produit produit;

  /*on passe en paramètre de la page cette entité
   pour pouvoir utiliser le meme formulaire
   pour le update er l'ajoute
  */
  ProduitPage({required this.produit});

  @override
  _ProduitPageState createState() => _ProduitPageState();
}

class _ProduitPageState extends State<ProduitPage> {
  final ProduitRepository _produitRepository = ProduitRepository();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _coordonneevendeurController =
  TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  String? _oldImageUrl;
  final _formKey = GlobalKey<FormState>(); // GlobalKey for form validation

  //pou pourvoir initilser les chmamps du formulaire avec les données lors du update
  @override
  void initState() {
    super.initState();
    _oldImageUrl = widget.produit.image;
    _prixController.text = widget.produit.prix.toString();
    _nomController.text = widget.produit.nom;
    _coordonneevendeurController.text = widget.produit.coordonneevendeur;
    _descriptionController.text = widget.produit.description;
    _typeController.text = widget.produit.type;
  }

  //l'objet de type file qui doit etre passer en paramètre des fonctions pour ajouter et modifier
  File? _selectedImage;

  //méthode pour l'ajout d'image
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Ajouter un produit'),
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
                if (_selectedImage != null) Container(
                  height: 250,
                    child: Image.file(_selectedImage!,fit: BoxFit.cover,)),
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
                  controller: _prixController,
                  decoration: InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _coordonneevendeurController,
                  decoration: InputDecoration(labelText: 'Téléphone'),
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
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Champ obligatoire";
                    } else {
                      return null;
                    }
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _typeController.text.isEmpty
                      ? null
                      : _typeController.text,
                  onChanged: (String? newValue) {
                    setState(() {
                      _typeController.text = newValue!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'produits artisanaux',
                      child: Text('Produits artisanaux'),
                    ),
                    DropdownMenuItem(
                      value: 'agro-alimentaire',
                      child: Text('Agro-alimentaire'),
                    ),
                  ],
                  decoration: InputDecoration(labelText: 'Type'),
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
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        final produit = Produit(
                          id: widget.produit.id,
                          image: _selectedImage != null ? '' : _oldImageUrl!,
                          nom: _nomController.text,
                          prix: int.parse(_prixController.text),
                          coordonneevendeur: _coordonneevendeurController.text,
                          description: _descriptionController.text,
                          type: _typeController.text,
                          statut: true, utilisateurId: _auth.currentUser!.uid,
                        );

                        if (widget.produit.id.isNotEmpty) {
                          _produitRepository
                              .mettreAJourProduit(produit, _selectedImage)
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Produit mis à jour avec succès'),
                              ),
                            );
                          }).catchError((error) {
                            // Afficher un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de la mise à jour du produit',
                                ),
                              ),
                            );
                          });
                        } else {
                          // Ajouter un nouveau produit
                          _produitRepository
                              .ajouterProduit(produit, _selectedImage!)
                              .then((_) {
                            // Réinitialiser les champs et l'image sélectionnée
                            setState(() {
                              _selectedImage = null;
                              _prixController.clear();
                              _coordonneevendeurController.clear();
                              _descriptionController.clear();
                              _typeController.clear();
                            });

                            // Afficher un message de succès
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Produit ajouté avec succès'),
                              ),
                            );
                          }).catchError((error) {
                            // Afficher un message d'erreur
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Erreur lors de l\'ajout du produit',
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
                  },
                  child: Text(
                    widget.produit.id.isNotEmpty ? 'Mettre à jour' : 'Ajouter',
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
