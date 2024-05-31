import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../common/size_valiable/utill_size.dart';


class DetailIconText extends StatelessWidget {
  IconData icons;
  String title;
  VoidCallback callBack;
  Color? colors;
   DetailIconText({
    super.key,
     required this.icons,
     required this.title,
     required this.callBack,
     this.colors,
  }

  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callBack,
      child: Column(
        children: [
           Icon(icons,color:colors , size: 25,),
          HeightBox(smallHeight),
          title.text.size(smallFontSize).fontWeight(FontWeight.w700).make(),
        ],
      ),
    );
  }
}