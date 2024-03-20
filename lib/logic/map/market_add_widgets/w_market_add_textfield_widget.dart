import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../color/color_box.dart';
import '../../../size_valiable/utill_size.dart';

class MarketNameTextField extends StatelessWidget {
   MarketNameTextField({
    super.key,
    required TextEditingController marketNameController,
  }) : _marketNameController = marketNameController;

  final TextEditingController _marketNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "가게 이름"
            .text
            .size(normalFontSize)
            .fontWeight(FontWeight.w700)
            .make()
            .pOnly(left: 25),
        HeightBox(normalHeight),
        TextField(
          style: const TextStyle(color: Colors.black),
          controller: _marketNameController,
          decoration: InputDecoration(
            hintText: "가게 이름",
            filled: true,
            fillColor: greyColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // 테두리에 라운드 적용
              borderSide: BorderSide.none, // 테두리 제거
            ),
          ),
        ).pOnly(left: 25, right: 25)
      ],
    );
  }
}