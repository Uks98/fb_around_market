

import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginContainer extends StatelessWidget {
  LoginContainer({super.key,required this.loginSite,required this.containerColor,required this.textColor,required this.callback,this.isLabel,this.assetImage});
  final String loginSite;
  final Color containerColor;
  final Color textColor;
  final String? assetImage;
  VoidCallback callback;
  bool? isLabel = true;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style : ButtonStyle(
        backgroundColor:  MaterialStateProperty.all<Color>(containerColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),  // 원하는 라운드 크기
          ),
        ),
      ),
        onPressed: callback, child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            isLabel == true ? Image.asset(assetImage ?? "",width: bigWidth+5,height:bigHeight + 10,) : const SizedBox(),
            loginSite.text.color(textColor).make(),
            Container()
          ],
        ),).pOnly(left: 20,right: 20);
  }
}
