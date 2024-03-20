
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../color/color_box.dart';
import '../../../size_valiable/utill_size.dart';

class TextButtonWidget extends StatelessWidget {
  String buttonName;
  VoidCallback callback;
  TextButtonWidget({
    super.key,
    required this.buttonName,
    required this.callback
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: callback,
      child: buttonName
          .text
          .color(baseColor)
          .fontWeight(FontWeight.w700).fontWeight(FontWeight.bold)
          .make()
          .pOnly(),);
  }
}
