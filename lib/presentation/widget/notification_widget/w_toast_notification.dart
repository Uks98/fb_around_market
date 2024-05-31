

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/color/color_box.dart';
import '../../../common/size_valiable/utill_size.dart';


class ToastNotification{

  static void warningToast(String msg,){
    Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT,backgroundColor: Colors.black,textColor: Colors.white,fontSize: 16);
  }
  static void missionWriteLen(BuildContext context,String explain){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 100,
          child: Row(
            children: [
              WidthBox(bigWidth),
              Image.asset("assets/app_pro_color.png",scale: 2,),
              explain.text.fontWeight(FontWeight.w700).size(biggestFontSize).make()
            ],
          ),
        ),
        elevation: 0.0,
        backgroundColor: cardColor,

        margin: const EdgeInsets.only(bottom: 880),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}