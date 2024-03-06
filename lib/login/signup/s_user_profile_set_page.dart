import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/logic/image_compress.dart';
import 'package:fb_around_market/notification_widget/w_toast_notification.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpUserProfileSetPage extends StatefulWidget {
  const SignUpUserProfileSetPage({super.key});

  @override
  State<SignUpUserProfileSetPage> createState() => _SignUpUserProfileSetPageState();
}

class _SignUpUserProfileSetPageState extends State<SignUpUserProfileSetPage> {
  Uint8List? imageData; //이미지 파일 리스트, 이미지 데이터 가져오기
  XFile? image;
  final ComplexImageLogicBox _imageCompress = ComplexImageLogicBox();
  final ToastNotification _toastNotification = ToastNotification();
  void saveUserProfileImage()async{
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref("profile/").child("${DateTime.now().microsecondsSinceEpoch}_${image?.name ?? "??"}.jpg");
    final compressImage =  await _imageCompress.imageCompressList(imageData!);
    await storageRef.putData(compressImage);
    print("이미지 저장");
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeightBox(30),
            "나만의 프로필을 \n설정하세요"
                .text
                .fontWeight(FontWeight.w700)
                .size(bigFontSize + 10)
                .make()
                .pOnly(left: 20),
            const HeightBox(80),
            Center(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        ImagePicker imagePicker = ImagePicker();
                        final img = await imagePicker.pickImage(source: ImageSource.gallery);
                        imageData = await img?.readAsBytes();
                        setState(() {});
                      },
                      child: imageData != null ? CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 130,
                        backgroundImage: MemoryImage(imageData!),
                      ) : CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 130,
                      ),
                    ),
                    const Positioned(
                      right: 20,
                      bottom: 20,
                      child: Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                    ),
                  ],
                )),
            HeightBox(80),
            Center(child: ElevatedButton(onPressed: () async{
               //final db = FirebaseFirestore.instance;
               //await db.collection("aaaa").add({"title" : "aaa"});
              if(imageData != null){
              saveUserProfileImage();
              }else{
                _toastNotification.loginToast("사진을 추가해주세요");
              }
             // context.go("/signUp/signUpName");
            }, child: "다음".text.make()))
          ],
        ),
      ),
    );
  }
}
