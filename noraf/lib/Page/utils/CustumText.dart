import 'package:flutter/cupertino.dart';

Widget CustumText(String text,Color color,String fontfamity,double size){
  return Text(text,style: TextStyle(color: color,fontFamily: fontfamity,fontSize: size),);
}