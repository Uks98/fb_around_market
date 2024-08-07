
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import '../../../domain/model/market_add_data/map_marker_data.dart';
import '../../view/marker_detail_page/s_market_detail_page.dart';

class AllPlaceMapData{

  bool waitingConnection(AsyncSnapshot future){
    return future.connectionState == ConnectionState.waiting;
  }
  ///마켓의 세부정보가 담겨있는 스트림을 가져옵니다.
  List<MarketData> allMarketData(AsyncSnapshot snapshot) {
     return snapshot.data?.docs.map<MarketData>((e) {
       final data = e.data();
       return MarketData.fromJson(data).copyWith(markerId: data["markerId"]);
     }).toList() ?? [];
   }
/// 메인 페이지에 마커를 선택할 시 상세페이지로 이동하는데 사용 되는 함수입니다.
  void goDetailPageAtAllPlaceMapMarker(NMarker marker, BuildContext context, geoPointX, geoPointY, Map<String, dynamic> markerData, QueryDocumentSnapshot<Map<String, dynamic>> doc, int distance) {
    marker.setOnTapListener(
          (overlay) =>
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) {
                  return MarketDetailPage(gpsX: geoPointX,
                    gpsY: geoPointY,
                    id: markerData["markerId"],
                    uid: markerData["uid"],
                    docId: doc.id,
                    dayOfWeek: markerData["dayOfWeek"],
                    distance: distance,
                    //데이터 넘겨서 매칭 되는 요일만 색상 변경
                  );
                }
            ),
          ),
    );
  }
  void goDetailPageAtAllPlaceTile(BuildContext context,String id,String uid,String? docId,double gpsX,double gpsY,List<dynamic> dayOfWeek){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            MarketDetailPage(
              id: id.toString(),
              uid: uid.toString(),
              docId: docId ?? "123",
              gpsX: gpsX,
              gpsY: gpsY,
              dayOfWeek: dayOfWeek
            ),
      ),
    );
  }
}