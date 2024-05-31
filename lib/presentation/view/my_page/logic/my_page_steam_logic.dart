
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../ropository/firs_base_mixin/fire_base_queue.dart';

class MyPageStreamLogic with FireBaseInitialize{
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserFavorite() {
    // StreamController 생성
    final controller = StreamController<QuerySnapshot<Map<String, dynamic>>>();

    // 비동기 작업을 시작하는 함수
    Future<void> startAsyncWork() async {
      final userId = await firestoreInit.collection("users").where(
          "userUid", isEqualTo: userUid).get();
      final str = userId.docs.first.id;

      final favorites = firestoreInit.collection("users").doc(str)
          .collection("favorite")
          .snapshots();

      // Stream을 StreamController에 추가
      favorites.listen((data) {
        controller.add(data);
      }, onDone: () {
        controller.close();
      });
    }
    // 비동기 작업 시작
    startAsyncWork();
    // 사용자에게 StreamController의 Stream 반환
    return controller.stream;
  }
  ///유저가 작성한 길거리 음식점의 목록들을 불러오는 스트림입니다.
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserWriteList() {
    return firestoreInit.collection("mapMarker").where("uid", isEqualTo : userUid).snapshots();
  }
  ///유저의 프로필 정보를 불러오는 스트림입니다.
  Stream<QuerySnapshot<Map<String,dynamic>>> streamProfileInfo(){
    return FirebaseFirestore.instance.collection("users").where("userUid",isEqualTo:userUid).snapshots();
  }
}