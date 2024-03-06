import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class SignUpAddNamePage extends StatelessWidget {
  SignUpAddNamePage({super.key});

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
            const HeightBox(100),
            Center(
                child: Stack(
              children: [
                GestureDetector(
                  onTap: ()async{

                  },
                  child: CircleAvatar(
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
            Center(child: ElevatedButton(onPressed: () {

            }, child: "다음".text.make()))
          ],
        ),
      ),
    );
  }
}
