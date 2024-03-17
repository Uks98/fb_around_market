import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MyPage extends StatefulWidget {
  MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}
//유저의 리뷰를 불러오는 stream입니다.

class _MyPageState extends State<MyPage> with FireBaseInitialize{
  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserFavorite() {
    // StreamController 생성
    final controller = StreamController<QuerySnapshot<Map<String, dynamic>>>();

    // 비동기 작업을 시작하는 함수
    Future<void> startAsyncWork() async {
      final userId = await firestoreInit.collection("users").where(
          "userUid", isEqualTo: userUid).get();
      final str = userId.docs.map((e) =>
          e.id.replaceAll("(", "").replaceAll(")", ""));
      String convertString = str.toString().replaceAll("(", "").replaceAll(
          ")", "");

      // 여기서는 예시로 docId를 직접 넣었습니다. 실제 사용시에는 적절한 값을 설정해야 합니다.
      final review = firestoreInit.collection("users").doc(convertString)
          .collection("favorites").orderBy("timestamp")
          .snapshots();

      // Stream을 StreamController에 추가
      review.listen((data) {
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: baseColor,
        elevation: 1,
        title: Text(
          "마이 페이지",
          style: TextStyle(color:Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.settings,
                color: greyFontColor,
              ))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                //bool isChecked = _userInfo.funUserCheck(UserInfoData.user!.uid);
                if (index == 0) {

                }else if(index == 1){
                  return StreamBuilder(stream: streamUserFavorite(), builder: (context,snapshot){
                    return Container();
                  });
                } else if (index == 2) {
                  return Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        child: ListView.builder(
                          itemBuilder: (context, index) {

                          },
                          itemCount: 4,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                        height: 600,
                      ),
                    ],
                  );
                }
                return Container();
              },
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
  Widget campingListWidget(String imaUrl, String name, String location, String x, double width, double height) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(imaUrl), fit: BoxFit.fill),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    location.toString(),
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(x,
                      style:
                      TextStyle(fontSize: 13,color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}