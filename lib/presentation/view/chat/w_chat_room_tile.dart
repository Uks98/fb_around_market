import 'package:fb_around_market/common/size_valiable/utill_size.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatRoomTile extends StatelessWidget {
  const ChatRoomTile({super.key,required this.userDataImage,required this.userName});
  final String? userDataImage;
  final String userName;
  @override
  Widget build(BuildContext context) {
    String nullUserImage = "https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=";
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              userDataImage
                  ?.toString()
                  .replaceAll("(", "")
                  .replaceAll(")", "") ?? nullUserImage),
        ),
        WidthBox(normalWidth),
        userName.text.fontWeight(FontWeight.bold).size(smallFontSize).make()
      ],
    ).pOnly(top: normalHeight);
  }
}
