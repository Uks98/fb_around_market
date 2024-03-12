import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:velocity_x/velocity_x.dart';

import 'market_add_data/map_marker_data.dart';
import 'market_add_widgets/market_location_intro_widget.dart';
import 'market_add_widgets/w_market_add_textfield_widget.dart';

final marketIndex = StateProvider<int>((ref) => 0);

class MarkerAddPage extends StatefulWidget {
  double gpsX;
  double gpsY;
  String placeAddress;
  String? imagePath;
  String? uid;
  String? docId;

  MarkerAddPage({
    super.key,
    this.uid,
    this.docId,
    required this.gpsX,
    required this.gpsY,
    required this.placeAddress,
  });

  @override
  State<MarkerAddPage> createState() => _MarkerAddPageState();
}

class _MarkerAddPageState extends State<MarkerAddPage> with FireBaseInitialize{
  double get gpsY => widget.gpsY;

  double get gpsX => widget.gpsX;
  //매장 관련 리스트
  final List<String> _marketType = ['길거리', '매장', '편의점'];
  //카테고리 관련 리스트
  final List<String> payType = ["현금", "카드", "계좌이체"];
  List<String> paymentSelected = [];

  List<String> categoriesSelected = [];
  final List<Map<String, String>> categories = [
    {"붕어빵": "assets/pish.png"},
    {"땅콩빵": "assets/pinut.png"},
    {"타코야끼": "assets/taco.png"},
    {"탕후루": "assets/tanghu.png"},
    {"와플": "assets/waple.png"}
  ];
  String marketType = "";
  TextEditingController placeNameController = TextEditingController();
  final uidHub = FirebaseAuth.instance;
  final TextEditingController _marketNameController = TextEditingController();
  int _selectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final marker =
        NMarker(id: 'test', position: NLatLng(widget.gpsY, widget.gpsX));
    final cameraPosition = NCameraPosition(
      target: NLatLng(gpsY, gpsX),
      zoom: 15,
      bearing: 45,
      tilt: 30,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("가게 제보"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeightBox(biggestHeight),
            Center(
              child: SizedBox(
                width: mediaWidth - 50,
                height: 250,
                child: NaverMap(
                  options: NaverMapViewOptions(
                    initialCameraPosition: cameraPosition,
                  ),
                  onMapReady: (controller1) {
                    setState(() {
                      controller1.addOverlay(marker);
                    });
                    //print(marker);
                  },
                ),
              ),
            ),
            HeightBox(biggestHeight),
        
            ///마켓 위치 위젯 (수정 버튼 포함)
            MarketLocationIntroWidget(widget: widget, mediaWidth: mediaWidth),
            HeightBox(biggestHeight),
        
            ///마켓 이름 텍스트 필드
            MarketNameTextField(marketNameController: _marketNameController),
            HeightBox(biggestHeight),
        
            ///가게 형태
            marketTypeWidget(mediaWidth).pOnly(left: 25),
            HeightBox(biggestHeight),
        
            ///결제 방식
            paymentTypeWidget(mediaWidth).pOnly(left: 25),
        
            ///카테고리
            HeightBox(biggestHeight),
            categoriesWidget(mediaWidth),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: _marketNameController.text.isEmpty ? greyColor : baseColor,
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),),
                        onPressed: () async {
                          final documentId = await firestoreInit.collection("mapMarker").get();

                          final mapData = MarketData(
                              markerId: DateTime.now().microsecondsSinceEpoch.toString(),
                              uid: userUid,
                              locationName: widget.placeAddress,
                              marketName: placeNameController.text,
                              marketType: marketType,
                              kindOfCash: paymentSelected,
                              gpsX: widget.gpsX,
                              gpsY: widget.gpsY,
                              categories: categoriesSelected,
                          );
                          await firestoreInit.collection("mapMarker").add(mapData.toJson());
                        },
                        child: "가게 등록하기".text.size(20).fontWeight(FontWeight.w700).color(_marketNameController.text.isEmpty ? greyFontColor : Colors.white).make(),
                      ),
                    ),
                  ),
                  // widget.uid == uidHub.currentUser!.uid
                  //     ? ElevatedButton(
                  //         onPressed: () async {
                  //           final db = FirebaseFirestore.instance;
                  //           final col =
                  //               db.collection("mapMarker").doc(widget.docId);
                  //           col.update({
                  //             "marketName": placeNameController.text,
                  //           });
                  //           Navigator.of(context).pop();
                  //         },
                  //         child: Text("수정하기"))
                  //     : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column categoriesWidget(double mediaWidth) {
    return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "메뉴 카테고리"
                  .text
                  .size(normalFontSize)
                  .fontWeight(FontWeight.w700)
                  .make(),
              HeightBox(biggestHeight),
              VxBox(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelected = categoriesSelected.contains(categories[index].keys.toString());
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              categoriesSelected.remove(categories[index].keys.toString());
                            } else {
                              categoriesSelected.add(categories[index].keys.toString());
                            }
                          });

                        },
                        child: VxBox(
                          child: Column(
                            children: [
                              Image.asset(
                                categories[index]
                                    .values
                                    .toString()
                                    .replaceAll("(", "")
                                    .replaceAll(")", "")
                                    .toString(),
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                              HeightBox(smallHeight),
                              Center(
                                child: categories[index]
                                    .keys
                                    .toString()
                                    .replaceAll(")", "")
                                    .replaceAll("(", "")
                                    .text
                                    .fontWeight(FontWeight.w700)
                                    .color(isSelected
                                        ? selectColor
                                        : greyFontColor)
                                    .make(),
                              ),
                            ],
                          ).pOnly(top: 10),
                        )
                            .roundedFull
                            .width(mediaWidth / 5)
                            .border(
                                color: isSelected ? baseColor : greyColor,
                                width: 2)
                            .margin(const EdgeInsets.all(3))
                            .make());
                  },
                  itemCount: categories.length,
                ),
              )
                  .width(mediaWidth - 40)
                  .withRounded(value: 15)
                  .height(105)
                  .color(greyColor)
                  .make(),
              HeightBox(biggestHeight),
              HeightBox(biggestHeight),
            ],
          );
  }

  Column paymentTypeWidget(double mediaWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "결제 방식 (선택)"
            .text
            .size(normalFontSize)
            .fontWeight(FontWeight.w700)
            .make(),
        HeightBox(biggestHeight),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    bool isSelected = paymentSelected.contains(payType[index]);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            paymentSelected.remove(payType[index]);
                            print(paymentSelected);
                          } else {
                            paymentSelected.add(payType[index]);
                            print(paymentSelected);
                          }
                        });
                      },
                      child: VxBox(
                        child: Center(
                          child: payType[index]
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(isSelected ? selectColor : greyFontColor)
                              .make(),
                        ),
                      )
                          .withRounded(value: normalWidth)
                          .width(mediaWidth / 3)
                          .height(20)
                          .border(
                              color: isSelected ? baseColor : greyColor,
                              width: 2)
                          .make(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return WidthBox(normalWidth);
                  },
                  itemCount: payType.length,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Column marketTypeWidget(double mediaWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "가게 형태".text.size(normalFontSize).fontWeight(FontWeight.w700).make(),
        HeightBox(biggestHeight),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectIndex = index;
                        });
                      },
                      child: VxBox(
                              child: Center(
                                  child: _marketType[index]
                                      .text
                                      .fontWeight(FontWeight.w700)
                                      .color(_selectIndex == index
                                          ? selectColor
                                          : greyFontColor)
                                      .make()))
                          .withRounded(value: normalWidth)
                          .width(mediaWidth / 3)
                          .height(20)
                          .border(
                              color:
                                  _selectIndex == index ? baseColor : greyColor,
                              width: 2)
                          .make(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return WidthBox(normalWidth);
                  },
                  itemCount: _marketType.length,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}