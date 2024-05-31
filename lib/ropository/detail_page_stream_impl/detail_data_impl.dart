import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DetailStreamDataImpl{
  /// 마커로 저장된 길거리 음식점에 정보를 가져오는 스트림
  Stream<QuerySnapshot<Map<String,dynamic>>> streamMapData();
  /// 회원가입시 저장된 회원정보를 가져오는 스트림
  Stream<QuerySnapshot<Map<String,dynamic>>> streamProfileInfo();
  /// 로그인한 사용자의 리뷰를 가져오는 스트림
  Stream<QuerySnapshot<Map<String,dynamic>>> streamReview();
}