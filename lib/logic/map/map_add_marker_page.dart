import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:velocity_x/velocity_x.dart';

import 'market_add_data/map_marker_data.dart';


class MarkerAddPage extends StatefulWidget {
  double gpsX;
  double gpsY;
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
      }
      );

  @override
  State<MarkerAddPage> createState() => _MarkerAddPageState();
}

class _MarkerAddPageState extends State<MarkerAddPage> {
  double get gpsY => widget.gpsY;

  double get gpsX => widget.gpsX;
  final List<String> _labels = ['길거리', '매장', '편의점'];
  String marketType = "";
  TextEditingController placeNameController = TextEditingController();
  final List<bool> _selections = List.generate(3, (_) => false);
  final uidHub = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final TextEditingController _marketNameController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaWidth = MediaQuery.of(context).size.width;
    final marker = NMarker(id: 'test', position: NLatLng(widget.gpsY, widget.gpsX));
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
            HeightBox(normalHeight),
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
            marketLocationIntroWidget(mediaWidth),
            HeightBox(biggestHeight),
            ///마켓 이름 텍스트 필드
            marketNameTextFeild(marketNameController: _marketNameController),

            Text("가게 위치 ${widget.placeAddress}"),
            TextField(
              controller: placeNameController,
            ),
            ToggleButtons(
              isSelected: _selections,
              onPressed: (int index) {
                setState(() {
                  _selections[index] = !_selections[index];
                  marketType = _labels[index];
                });
              },
              borderRadius: BorderRadius.circular(30),
              fillColor: Colors.blue,
              selectedColor: Colors.white,
              color: Colors.black,
              children: _labels.map((e) => Text(e.toString())).toList(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async{
                        final documentId = await FirebaseFirestore.instance.collection("mapMarker").get();
                        final mapData = MarketData(
                          markerId: documentId.docs.first.id,
                          uid: uidHub.currentUser!.uid,
                          locationName: widget.placeAddress,
                            marketName:placeNameController.text,
                          marketType: marketType,
                          kindOfCash: "",
                          gpsX: widget.gpsX,
                          gpsY: widget.gpsY
                        );
                        await db.collection("mapMarker").add(
                          mapData.toJson());
                      },
                      child: Text("가게 등록하기"),
                    ),
                  ),
                  widget.uid == uidHub.currentUser!.uid ? ElevatedButton(onPressed:()async{
                    final db = FirebaseFirestore.instance;
                    final col = db.collection("mapMarker").doc(widget.docId);
                    col.update({
                      "marketName" : placeNameController.text,
                    });
                    Navigator.of(context).pop();
                  }, child:Text("수정하기")) : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column marketLocationIntroWidget(double mediaWidth) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          "가게 위치".text.size(bigFontSize).fontWeight(FontWeight.w700).make(),
              HeightBox(normalHeight),
              Stack(
                children: [
                  VxBox().color(greyColor).width(mediaWidth - 50).height(50).withRounded(value: normalWidth).make(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.placeAddress.text.size(normalFontSize).color(greyFontColor).make().pOnly(top: 3,left: 10),
                      const WidthBox(350),
                      TextButton(onPressed: (){}, child: "수정".text.color(baseColor).fontWeight(FontWeight.w700).make())
                    ],
                  )
                ],
              )
            ],
          );
  }
}

class marketNameTextFeild extends StatelessWidget {
  const marketNameTextFeild({
    super.key,
    required TextEditingController marketNameController,
  }) : _marketNameController = marketNameController;

  final TextEditingController _marketNameController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "가게 이름".text.size(bigFontSize).fontWeight(FontWeight.w700).make().pOnly(left: 25),
        HeightBox(normalHeight),
        TextField(
          style: const TextStyle(color: Colors.black),
          controller: _marketNameController,
          decoration: InputDecoration(
            hintText: "가게 이름",
            filled: true,
            fillColor: greyColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // 테두리에 라운드 적용
              borderSide: BorderSide.none, // 테두리 제거
            ),
          ),
        ).pOnly(left: 25,right: 25)
      ],
    );
  }
}
