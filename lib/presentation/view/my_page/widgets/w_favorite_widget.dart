import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../common/color/color_box.dart';
import '../../../../common/size_valiable/utill_size.dart';


class FavoriteWidget extends StatelessWidget {
  final String imagePath;
  final String categories;
  final String marketName;
  final String kindOfCash;
  const FavoriteWidget({super.key, required this.imagePath, required this.categories, required this.marketName, required this.kindOfCash});

  @override
  Widget build(BuildContext context) {
    return VxBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidthBox(bigHeight),
            CircleAvatar(
              backgroundColor:baseColor,
              radius: 30,
              backgroundImage:AssetImage(imagePath),
            ).pOnly(top: biggestHeight),
            WidthBox(bigHeight),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                "#$categories".replaceAll("(", "").replaceAll(")","").text.size(smallFontSize).color(Colors.grey[800]).make(),
                marketName.text.fontWeight(FontWeight.w700).color(Colors.white).size(normalFontSize).make(),
                kindOfCash.text.size(smallFontSize).color(Colors.grey[800]).color(Colors.white).make(),
              ],
            ).pOnly(top: 0)
          ],
        )

    ).width(250).height(100).color(baseColor).withRounded(value: normalWidth).make();
  }
}
