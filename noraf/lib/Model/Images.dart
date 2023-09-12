import 'package:cloud_firestore/cloud_firestore.dart';
class Images {
 String uid;
 String Image_1;
 String Image_2;
 String Image_3;
 String Image_4;
 String id_logement;
Images({required this.uid,required this.Image_1,required this.Image_2,required this.Image_3,required this.Image_4,required this.id_logement,});

Map<String, dynamic> toJson(){
return{
'uid' : uid ,
'Image_1' : Image_1 ,
'Image_2' : Image_2 ,
'Image_3' : Image_3 ,
'Image_4' : Image_4 ,
'id_logement' : id_logement ,
};}
static Images fromJson(Map<String,dynamic> json) => Images(uid: json['uid'],Image_1: json['Image_1'],Image_2: json['Image_2'],Image_3: json['Image_3'],Image_4: json['Image_4'],id_logement: json['id_logement'],);

}