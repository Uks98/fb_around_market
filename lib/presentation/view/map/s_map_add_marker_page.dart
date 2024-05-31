import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../common/color/color_box.dart';
import '../../../common/size_valiable/utill_size.dart';
import '../../../domain/model/market_add_data/map_marker_data.dart';
import '../../../ropository/firs_base_mixin/fire_base_queue.dart';
import '../../widget/market_add_widgets/w_market_add_textfield_widget.dart';
import '../../widget/market_add_widgets/w_market_location_intro_widget.dart';

final marketIndex = StateProvider<int>((ref) => 0);

class MarkerAddPage extends StatefulWidget {
  double gpsX;
  double gpsY;
  double? currentX; //현재 위치
  double? currentY; //현재 위치
  String placeAddress;
  String? imagePath;
  String? uid;
  String? docId;

  MarkerAddPage(
      {super.key,
      this.uid,
      this.docId,
      required this.gpsX,
      required this.gpsY,
      required this.placeAddress,
      this.currentX,
      this.currentY});

  @override
  State<MarkerAddPage> createState() => _MarkerAddPageState();
}

class _MarkerAddPageState extends State<MarkerAddPage> with FireBaseInitialize {
  double get gpsY => widget.gpsY;

  double get gpsX => widget.gpsX;

  double? distance; //거리 계산

  //매장 리스트
  final List<String> _marketType = ['길거리', '매장', '편의점'];
  String market = "길거리";

  //카테고리  리스트
  final List<String> payType = ["현금", "카드", "계좌이체"];
  List<String> paymentSelected = [];

  //출몰 시기 리스트
  final List<String> dayOfWeekList = ["월", "화", "수", "목", "금", "토", "일"];

  final List<String> dayOfWeekSelectList = [];

  List<String> categoriesSelected = [];
  List<String> categoriesImage = [];
  final List<Map<String, String>> categories = [
    {"붕어빵": "assets/pish.png"},
    {"땅콩빵": "assets/pinut.png"},
    {"타코야끼": "assets/taco.png"},
    {"탕후루": "assets/tanghu.png"},
    {"와플": "assets/waple.png"}
  ];
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
    final marker = NMarker(id: 'markerPin', position: NLatLng(widget.gpsY, widget.gpsX));
    final cameraPosition = NCameraPosition(
      target: NLatLng(gpsY, gpsX),
      zoom: 15,
      bearing: 45,
      tilt: 30,
    );
    return GestureDetector(
      onTap: ()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                      final _latLng = NLatLng(widget.gpsY, widget.gpsX); //현재 거리
                      final _loadMarketLocation = NLatLng(
                        double.parse(
                          widget.currentY.toString(),
                        ),
                        double.parse(
                          widget.currentX.toString(),
                        ),
                      );
                      distance = _latLng.distanceTo(_loadMarketLocation);
                    },
                  ),
                ),
              ),
              HeightBox(biggestHeight),

              ///마켓 위치 위젯
              MarketLocationIntroWidget(widget: widget, mediaWidth: mediaWidth),
              HeightBox(biggestHeight),

              ///마켓 이름 텍스트 필드
              MarketNameTextField(marketNameController: _marketNameController,),
              HeightBox(biggestHeight),

              ///가게 형태
              marketTypeWidget(mediaWidth).pOnly(left: 25),
              HeightBox(biggestHeight),

              ///결제 방식
              paymentTypeWidget(mediaWidth).pOnly(left: 25),
              HeightBox(biggestHeight),

              ///출몰 시기
              dayOfWeekWidget(mediaWidth).pOnly(left: 25),

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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _marketNameController.text.isEmpty
                                ? greyColor
                                : baseColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          onPressed: () async {
                            final mapData = MarketData(
                                markerId: DateTime.now()
                                    .microsecondsSinceEpoch
                                    .toString(),
                                uid: userUid,
                                locationName: widget.placeAddress,
                                marketName: _marketNameController.text,
                                marketType: market,
                                kindOfCash: paymentSelected,
                                gpsX: widget.gpsX,
                                gpsY: widget.gpsY,
                                categories: categoriesSelected,
                                categoryImage: categoriesImage[0],
                                dayOfWeek: dayOfWeekSelectList,
                                distance: distance);
                            await firestoreInit
                                .collection("mapMarker")
                                .add(mapData.toJson());
                            if(mounted){
                              context.goNamed("main");
                            }

                          },
                          child: "가게 등록하기"
                              .text
                              .size(20)
                              .fontWeight(FontWeight.w700)
                              .color(_marketNameController.text.isEmpty
                                  ? greyFontColor
                                  : Colors.white)
                              .make(),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column categoriesWidget(double mediaWidth) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "메뉴 카테고리".text.size(normalFontSize).fontWeight(FontWeight.w700).make(),
        HeightBox(biggestHeight),
        VxBox(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              bool isSelected = categoriesSelected
                  .contains(categories[index].keys.toString());
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        categoriesSelected
                            .remove(categories[index].keys.toString());
                        categoriesImage
                            .remove(categories[index].values.toString());
                      } else {
                        categoriesSelected
                            .add(categories[index].keys.toString());
                        categoriesImage
                            .add(categories[index].values.toString());
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
                              .color(
                                  isSelected ? selectColor : categoryFontColor)
                              .make(),
                        ),
                      ],
                    ).pOnly(top: 10),
                  )
                      .roundedFull
                      .width(mediaWidth / 5)
                      .border(
                          color: isSelected ? baseColor : greyColor, width: 2)
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
                            paymentSelected.remove(payType[index]
                                .replaceAll("(", "")
                                .replaceAll(")", ""));
                          } else {
                            paymentSelected.add(payType[index]
                                .replaceAll("(", "")
                                .replaceAll(")", ""));
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

  Column dayOfWeekWidget(double mediaWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "출몰시기 (선택)"
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
                    bool isSelected = dayOfWeekSelectList
                        .contains(dayOfWeekList[index].toString());
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            dayOfWeekSelectList
                                .remove(dayOfWeekList[index].toString());
                          } else {
                            dayOfWeekSelectList
                                .add(dayOfWeekList[index].toString());
                          }
                        });
                      },
                      child: VxBox(
                        child: Center(
                          child: dayOfWeekList[index]
                              .text
                              .fontWeight(FontWeight.w700)
                              .color(isSelected ? selectColor : greyFontColor)
                              .make(),
                        ),
                      )
                          .roundedFull
                          .width(mediaWidth / 8)
                          .border(
                              color: isSelected ? selectColor : greyFontColor,
                              width: 1)
                          .make(),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return WidthBox(normalWidth);
                  },
                  itemCount: dayOfWeekList.length,
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
                          market = _marketType[index];
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
