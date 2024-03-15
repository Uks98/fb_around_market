
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class LocationClass{
  Future<Position> getLocation(BuildContext context) async {
    LocationPermission per = await Geolocator.checkPermission();
    if (per == LocationPermission.denied || per == LocationPermission.deniedForever) {
      LocationPermission per1 = await Geolocator.requestPermission();
      if (per1 == LocationPermission.denied || per1 == LocationPermission.deniedForever) {
        toastMessage(context,"위치 권한이 거부되었습니다.");
        // 권한 거부 시 예외 던지기
        throw Exception("위치 권한이 거부되었습니다.");
      }
    }
    Position currentLoc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    toastMessage(context, "정보를 불러왔습니다.");
    return currentLoc;
  }

  void toastMessage(BuildContext context,String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text),backgroundColor: Colors.black,));
  }
}