import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class GetImage extends StatelessWidget {
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Colors.black,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Photo du logement",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),

          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(

                child: IconButton(
                  icon: Icon(Icons.camera_alt), onPressed: () async {
                  XFile? result = await picker.pickImage(source: ImageSource.camera);

                  try {
                    File image = File(result!.path);

                    Navigator.of(context).pop(image);
                  } on Exception catch (e) {
                    // TODO
                    print(e);
                  }
                },
                ),
              ),
              SizedBox(
                width: 20,
              ),
              CircleAvatar(

                child: IconButton(
                  icon: Icon(Icons.image), onPressed: () async {
                  XFile? result = await picker.pickImage(source: ImageSource.gallery);
                  try {
                    File? image = File(result!.path);
                    Navigator.of(context).pop(image);
                  } on Exception catch (e) {
                    // TODO
                    print(e);
                  }

                },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
