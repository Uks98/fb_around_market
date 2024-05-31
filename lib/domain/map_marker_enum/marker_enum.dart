

import 'package:flutter_naver_map/flutter_naver_map.dart';

enum MarkerIcon{
  fish(NOverlayImage.fromAssetImage("assets/pish.png")),
  waple(NOverlayImage.fromAssetImage("assets/waple.png")),
  pinut(NOverlayImage.fromAssetImage("assets/pinut.png")),
  taco(NOverlayImage.fromAssetImage("assets/taco.png",)),
  tang(NOverlayImage.fromAssetImage("assets/tanghu.png"));

  final NOverlayImage name;

  const MarkerIcon(this.name);

  static markerConvertWithMenu (Map<String,dynamic> data){
    switch(data["categories"][0].toString().replaceAll("(", "").replaceAll(")", "")){
      case "붕어빵":
        return MarkerIcon.fish.name;
      case "탕후루":
        MarkerIcon.tang.name;
        return MarkerIcon.tang.name;
      case "와플":
        return MarkerIcon.waple.name;
      case "타코야끼":
        return MarkerIcon.taco.name;
      case "땅콩빵":
        return MarkerIcon.pinut.name;
      default :
        MarkerIcon.waple.name;
    }
  }
}
