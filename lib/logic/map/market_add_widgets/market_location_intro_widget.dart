import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../color/color_box.dart';
import '../../../size_valiable/utill_size.dart';
import '../map_add_marker_page.dart';
import 'button_widgets.dart';

class MarketLocationIntroWidget extends StatelessWidget {
  const MarketLocationIntroWidget({
    super.key,
    required this.widget,
    required this.mediaWidth,
  });

  final MarkerAddPage widget;
  final double mediaWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "가게 위치".text.size(normalFontSize).fontWeight(FontWeight.w700).make().pOnly(left: 0),
        HeightBox(normalHeight),
        VxBox(child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.placeAddress.text
                .size(normalFontSize)
                .color(greyFontColor)
                .make()
                .pOnly(top: 3, left: 20),
            const WidthBox(350),
            TextButtonWidget(buttonName:"수정",callback: (){}),
          ],
        ))
            .color(greyColor)
            .width(mediaWidth - 50)
            .height(50)
            .withRounded(value: normalWidth)
            .make()
      ],
    );
  }
}
