


import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//"Authorization": "KakaoAK 5026bccd6af45144199ef3f70f4b7ec7"
import 'location_data.dart';
import 'package:http/http.dart' as http;
class AddressName{
  List<LocationData> locationData = [];
  String addressName = "empty";
  Future<String?> getMapList({required BuildContext context, required double x,required double y}) async {
    var url = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=$x&y=$y";
    var response = await http.get(Uri.parse(url), headers: {"Authorization": "KakaoAK 5026bccd6af45144199ef3f70f4b7ec7"});
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      var res = json.decode(body) as Map<String,dynamic>;
      print(res);
      if(res["documents"] == ""){
        showDia(context);
      }
      for(final _res in res["documents"]){
        var roadAddress = _res['address'] as Map<String, dynamic>?;
        if(roadAddress != null){
          addressName = (roadAddress['address_name'].toString());
        }
      }
      if(addressName.isNotEmpty){
        print('Address Name: $addressName');
        return addressName;
      }
    }
    return "empty text";
  }

  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
  void showDia(BuildContext context){
    showDialog(
        context: context,
        builder: (context){
          return const AlertDialog(
            title: Text("🚨알림🚨"),
            content: Text("마지막 정보에요 😭"),
          );
        }
    );
  }
}
