import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../common/size_valiable/utill_size.dart';


class AchievementWidget extends StatelessWidget {
  String image;
  String aciName;
  Color color;
  AchievementWidget({
    super.key,
    required this.image,
    required this.aciName,
    required this.color
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Column(
          children: [
            Image.asset(image),
            aciName.text.fontWeight(FontWeight.w700).color(color).make()
          ],
        ),
        HeightBox(biggestHeight),
      ],
    );
  }
}