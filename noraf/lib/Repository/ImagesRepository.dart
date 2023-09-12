import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

import '../Model/Images.dart';
class ImagesRepository{

Future<Images?>readImages(Images images) async
{final docImages = FirebaseFirestore.instance.collection('Images').doc(images?.uid);
final snapshot = await docImages.get();if(snapshot.exists){
return Images.fromJson(snapshot.data()!);
}}



Stream<List<Images>> readAllImages()=>FirebaseFirestore.instance.collection('Images').snapshots().map((snapshot) => snapshot.docs.map((doc) =>Images.fromJson(doc.data())).toList());

Stream<List<Images>> readUserAllImages(String id_logement)=>FirebaseFirestore.instance.collection('Images').where("id_logement",isEqualTo: id_logement).snapshots().map((snapshot) => snapshot.docs.map((doc) =>Images.fromJson(doc.data())).toList());



Future<String?> uploadImage(File file,{required String path,required int i, required Images imgcherche}) async {
 ImagesRepository _ir = new ImagesRepository();
 var time = DateTime.now();
 var ext = Path.basename(file.path).split(".").last;
 String image = path+"_"+Path.basename(file.path).split(".")[0].toString()+time.toString()+"."+ext;
 String? urlimage = path+"/"+image;
 print(urlimage);

 try{

  final ref = FirebaseStorage.instance.ref().child(path+"/").child(image);
  print("On upload l'image");
  UploadTask uploadTask = ref.putFile(file);
  uploadTask.then((res) async {
   final link = await res.ref.getDownloadURL();
   print(link);
   if(i == 0){
    imgcherche!.Image_1 = link;
    _ir.UpdateImages1(imgcherche);
   }else if(i == 1){
    imgcherche!.Image_2 = link;
    _ir.UpdateImages2(imgcherche);
   }else if(i == 2){
    imgcherche!.Image_3 = link;
    _ir.UpdateImages3(imgcherche);

   }else if(i == 3){
    imgcherche!.Image_4 = link;
    _ir.UpdateImages4(imgcherche);
   }
   return link;
   print("Cherchons l'image");
  });



 }catch(e){
  print("Voici l'erreur : "+e.toString());
  return null;
 }
}



Future UpdateImages(Images Images) async{


final docImages = FirebaseFirestore.instance.collection('Images').doc(Images.uid);


 docImages.update({'Image_1' : Images.Image_1,'Image_2' : Images.Image_2,'Image_3' : Images.Image_3,'Image_4' : Images.Image_4,'id_logement' : Images.id_logement,});

}

 Future UpdateImages1(Images Images) async{


  final docImages = FirebaseFirestore.instance.collection('Images').doc(Images.uid);


  docImages.update({'Image_1' : Images.Image_1});

 }
 Future UpdateImages2(Images Images) async{


  final docImages = FirebaseFirestore.instance.collection('Images').doc(Images.uid);


  docImages.update({'Image_2' : Images.Image_2});

 }
 Future UpdateImages3(Images Images) async{


  final docImages = FirebaseFirestore.instance.collection('Images').doc(Images.uid);


  docImages.update({'Image_3' : Images.Image_3});

 }
 Future UpdateImages4(Images Images) async{


  final docImages = FirebaseFirestore.instance.collection('Images').doc(Images.uid);


  docImages.update({'Image_4' : Images.Image_4,});

 }


deleteImages(Images Images) async {
final docImages = FirebaseFirestore.instance.collection('Images').doc(Images.uid);
 docImages.delete();
}


Future<String?> AjoutImages(Images Images) async{
final docImages = FirebaseFirestore.instance.collection('Images').doc();
String path = docImages.path.split('/')[1];
Images.uid = path;
final data = Images.toJson();
docImages.set(data);
return path;
}

}