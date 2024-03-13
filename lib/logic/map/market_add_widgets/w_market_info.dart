import 'package:flutter/cupertino.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../size_valiable/utill_size.dart';

class MarketInfoWidget extends StatelessWidget {
  String intro;
  String value;
  MarketInfoWidget({
    super.key,
    required this.intro,
    required this.value,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        intro.text.fontWeight(FontWeight.w700).size(normalFontSize).make().pOnly(left: 60),
        value.text.fontWeight(FontWeight.w700).size(normalFontSize).make().pOnly(right: 60),
      ],
    );
  }
}