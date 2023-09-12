import 'dart:io';

import 'package:flutter/material.dart';


import 'package:path/path.dart' as Path;

import '../../Model/Images.dart';
import '../../Model/logement.dart';
import '../../Repository/AuthentificationService.dart';
import '../../Repository/ImagesRepository.dart';
import '../Acceuil.dart';
import '../utils/getImage.dart';


class AjoutImagelogement extends StatefulWidget {

  final logement log;

  AjoutImagelogement({required this.log});

  @override
  State<AjoutImagelogement> createState() => _AjoutImagelogementState();
}

class _AjoutImagelogementState extends State<AjoutImagelogement> {


  static File file2 = File("");
  static File file3 = File("");
  static File file4 = File("");
  static File file5 = File("");
  bool statutimage0 = true;
  bool statutimage1 = true;
  bool statutimage2 = true;
  bool statutimage3 = true;

  List<File> ImageaUpload = [file2,file3,file4,file5];
  AuthentificationService _authenticationService = AuthentificationService();

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Intérieure"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: loading ? SafeArea(
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(

              children: [
                Container(


                  child: Column(
                      children:[
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [


                            ],
                          ),
                        ),

                      ]

                  ),
                ),


                Container(
                    child: Icon(Icons.home,size: 180,)),

                Container(
                  child: Wrap(

                    children: [


                      FittedBox(child: Text("Choisissez des photos d'intérieurs",style: TextStyle(fontFamily: "Acme",fontSize: 60),)),

                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                Container(


                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            color: Color(0xff1195d5),
                            width: 150,
                            height: 150,
                            child:statutimage0 ?  Icon(Icons.add,color: Colors.white,) : Image.file(ImageaUpload[0],fit: BoxFit.cover,),
                          ),
                          onTap: () async {
                            final data = await showModalBottomSheet(context: context, builder: (ctx){
                              return GetImage();



                            });

                            setState(() {
                              ImageaUpload[0] = data;
                              statutimage0 = false;
                            });
                            print(ImageaUpload);
                            /*
                                  String? Urlimage = await PostService().uploadImage(data, path: "Post");
                                  if(Urlimage != null){
                                    print("Update de limage");
                                      Post post = Post(Pays: "", NomLocation: "", post_id: "", Quartier: "", Region: "", Ville: "", Description: "", Image_maison: Urlimage, Image_piece1: "", Image_piece2: "", Image_piece3: "", Image_piece4: "", Date_post: DateTime.now(), Prix: 0, Nombre_chambres: 0, Nombre_likes: 0, Nombre_salon: 0, Nombre_vues: 0);
                                      postService.UpdateImageMaison(post);
                                  }else{
                                    print("L'url est nul");
                                  }*/
                            if(data!= null){
                              loading = false;
                              setState(() { });
                              Future.delayed(Duration(seconds: 2), () {

                                // Code à exécuter après 5 secondes
                                setState(() {
                                  loading = true;
                                });
                              }
                              );
                            }
                          },
                        ),
                        SizedBox(width: 80.0,),
                        InkWell(
                          child: Container(
                            color:  Color(0xff1195d5),
                            width: 150,
                            height: 150,
                            child:statutimage1 ?  Icon(Icons.add,color: Colors.white,) : Image.file(ImageaUpload[1],fit: BoxFit.cover,),
                          ),
                          onTap: () async {
                            final data = await showModalBottomSheet(context: context, builder: (ctx){
                              return GetImage();



                            });

                            setState(() {
                              ImageaUpload[1] = data;
                              statutimage1 = false;
                            });
                            print(ImageaUpload);
                            /*
                                  String? Urlimage = await PostService().uploadImage(data, path: "Post");
                                  if(Urlimage != null){
                                    print("Update de limage");
                                      Post post = Post(Pays: "", NomLocation: "", post_id: "", Quartier: "", Region: "", Ville: "", Description: "", Image_maison: Urlimage, Image_piece1: "", Image_piece2: "", Image_piece3: "", Image_piece4: "", Date_post: DateTime.now(), Prix: 0, Nombre_chambres: 0, Nombre_likes: 0, Nombre_salon: 0, Nombre_vues: 0);
                                      postService.UpdateImageMaison(post);
                                  }else{
                                    print("L'url est nul");
                                  }*/
                            if(data!= null){
                              loading = false;
                              setState(() { });
                              Future.delayed(Duration(seconds: 2), () {

                                // Code à exécuter après 5 secondes
                                setState(() {
                                  loading = true;
                                });
                              }
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 50.0,),
                Container(


                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: Container(
                            color:  Color(0xff1195d5),
                            width: 150,
                            height: 150,
                            child:statutimage2 ?  Icon(Icons.add,color: Colors.white,) : Image.file(ImageaUpload[2],fit: BoxFit.cover,),
                          ),
                          onTap: () async {
                            final data = await showModalBottomSheet(context: context, builder: (ctx){
                              return GetImage();



                            });

                            setState(() {
                              ImageaUpload[2] = data;
                              statutimage2 = false;
                            });
                            print(ImageaUpload);
                            /*
                                  String? Urlimage = await PostService().uploadImage(data, path: "Post");
                                  if(Urlimage != null){
                                    print("Update de limage");
                                      Post post = Post(Pays: "", NomLocation: "", post_id: "", Quartier: "", Region: "", Ville: "", Description: "", Image_maison: Urlimage, Image_piece1: "", Image_piece2: "", Image_piece3: "", Image_piece4: "", Date_post: DateTime.now(), Prix: 0, Nombre_chambres: 0, Nombre_likes: 0, Nombre_salon: 0, Nombre_vues: 0);
                                      postService.UpdateImageMaison(post);
                                  }else{
                                    print("L'url est nul");
                                  }*/
                            if(data!= null){
                              loading = false;
                              setState(() { });
                              Future.delayed(Duration(seconds: 2), () {

                                // Code à exécuter après 5 secondes
                                setState(() {
                                  loading = true;
                                });
                              }
                              );
                            }
                          },
                        ),
                        SizedBox(width: 80.0,),

                        InkWell(
                          child: Container(
                            color:  Color(0xff1195d5),
                            width: 150,
                            height: 150,
                            child:statutimage3 ?  Icon(Icons.add,color: Colors.white,) : Image.file(ImageaUpload[3],fit: BoxFit.cover,),
                          ),
                          onTap: () async {
                            final data = await showModalBottomSheet(context: context, builder: (ctx){
                              return GetImage();



                            });

                            setState(() {
                              ImageaUpload[3] = data;
                              statutimage3 = false;
                            });
                            print(ImageaUpload);
                            /*
                                  String? Urlimage = await PostService().uploadImage(data, path: "Post");
                                  if(Urlimage != null){
                                    print("Update de limage");
                                      Post post = Post(Pays: "", NomLocation: "", post_id: "", Quartier: "", Region: "", Ville: "", Description: "", Image_maison: Urlimage, Image_piece1: "", Image_piece2: "", Image_piece3: "", Image_piece4: "", Date_post: DateTime.now(), Prix: 0, Nombre_chambres: 0, Nombre_likes: 0, Nombre_salon: 0, Nombre_vues: 0);
                                      postService.UpdateImageMaison(post);
                                  }else{
                                    print("L'url est nul");
                                  }*/
                            if(data!= null){
                              loading = false;
                              setState(() { });
                              Future.delayed(Duration(seconds: 2), () {

                                // Code à exécuter après 5 secondes
                                setState(() {
                                  loading = true;
                                });
                              }
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),

                TextButton(onPressed: () async{
                  ImagesRepository _ir = ImagesRepository();
                  Images img = new Images(uid: "uid", Image_1: "Image_1", Image_2: "Image_2", Image_3: "Image_3", Image_4: "Image_4", id_logement: this.widget.log.uid);
                  img.id_logement = this.widget.log.uid;
                  final path_img = await _ir.AjoutImages(img);
                  Images? imgcherche = await _ir.readImages(Images(uid: path_img!, Image_1: "Image_1", Image_2: "Image_2", Image_3: "Image_3", Image_4: "Image_4", id_logement: this.widget.log.uid));

                  for(int i =0;i<ImageaUpload.length;i++){


                      //Post post = Post(Pays: "", NomLocation: "", post_id: "", Quartier: "", Region: "", Ville: "", Description: "", Image_maison: "", Image_piece1: "", Image_piece2: "", Image_piece3: "", Image_piece4: "", Date_post: DateTime.now(), Prix: 0, Nombre_chambres: 0, Nombre_likes: 0, Nombre_salon: 0, Nombre_vues: 0);
                      final Urlimage = await _ir.uploadImage(ImageaUpload[i], path: "ImagesLogement", i: i, imgcherche: imgcherche!);





                  }

                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => Acceuil()));




                }, child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.orange,
                  ),
                    width: 150,
                    height: 50,
                    child: Center(child: Text("Valider",style: TextStyle(color: Colors.white),))))
              ],
            ),
          ),
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
