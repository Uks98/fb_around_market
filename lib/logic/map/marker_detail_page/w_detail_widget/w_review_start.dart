import 'package:fb_around_market/color/color_box.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ReviewLogic{
  //리뷰 평점에 따라 별의 갯수를 반환하는 로직
  static Widget returnStar(int star) {
    double iconSize = 20.0;
    Color color = baseColor;
    switch (star) {
      case 1:
        return Row(
          children: [
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 2:
        return Row(
          children: [
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 3:
        return Row(
          children: [
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 4:
        return Row(
          children: [
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
      case 5:
        return Row(
          children: [
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            ),
            Icon(
              Ionicons.star,
              size: iconSize,
              color: color,
            )
          ],
        );
    }
    return const CircularProgressIndicator();
  }}