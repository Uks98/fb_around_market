import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/ropository/firs_base_mixin/fire_base_queue.dart';
import 'package:flutter/cupertino.dart';

import '../model/market_add_data/map_marker_data.dart';

class MarketInteractionClass with FireBaseInitialize{
  ///사용자가 좋아하는 마켓을 저장하는 함수
   Future<void> getFavoritePlace(AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot, StateSetter setState,bool isFavorite,String docId) async {
    final teamList = snapshot.data?.docs ?? [];
    final userId = await firestoreInit.collection("users").where("userUid",isEqualTo:userUid).get();
    String convertString = userId.docs.first.id;
    setState(()=> isFavorite = !isFavorite);
    //favorite 즐겨찾기 데이터 추가
    for (final m in teamList) {
      final marketData = MarketData.fromJson(m.data()).toJson();
      final docRef = firestoreInit.collection("users").doc(convertString).collection("favorite").doc(docId);
      if (isFavorite) {
        await docRef.set({
          "favoriteItem": marketData,
        });
        print("추가");
      } else {
        await docRef.delete();
        print("삭제");
      }
    }
  }
}