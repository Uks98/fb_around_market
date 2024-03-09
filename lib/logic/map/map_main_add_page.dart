import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:velocity_x/velocity_x.dart';
import 'convert_location.dart';
import 'map_add_marker_page.dart';

class UserMarkerSelectPage extends StatefulWidget {
  const UserMarkerSelectPage({super.key});

  @override
  State<UserMarkerSelectPage> createState() => _UserMarkerSelectPageState();
}

class _UserMarkerSelectPageState extends State<UserMarkerSelectPage> {
  final marker = NMarker(
      id: 'test', position: const NLatLng(37.506932467450326, 127.02578661133796));

  //final marker2 = NMarker(id: 'test2',position: NLatLng(37.506932467450326, 37.506932467450326));
  AddressName addressName = AddressName();
  NaverMapController? naverMapController;
  String? addressNameText = "";
  double? convertGPSX;
  double? convertGPSY;
  void convertLocationData(double x, double y) async {
    addressNameText = (await addressName.getMapList(
        context: context,
        x: x ?? 127.02578661133796,
        y: y ?? 37.506932467450326));
    setState(() {});
  }

  Stream<QuerySnapshot> streamMapMarker() {
    final db = FirebaseFirestore.instance;
    return db.collection("mapMarker").snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    convertLocationData(127.02578661133796, 37.506932467450326);
  }

  @override
  Widget build(BuildContext context) {
    final double mediaWidthSize = MediaQuery.of(context).size.width;
    final markers = <NMarker>{marker};
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              nightModeEnable: true,
            ),
            onMapTapped: (x, y) {
              convertGPSX = y.latitude;
              convertGPSY = y.longitude;
              convertLocationData(y.longitude, y.latitude);
              setState(() {
                markers.add(NMarker(
                    id: 'test3', position: NLatLng(y.latitude, y.longitude)));
                naverMapController?.addOverlayAll(markers);
              });
            },
            onMapReady: (controller1) {
              naverMapController = controller1;
              setState(() {
                naverMapController!.addOverlayAll(markers);
              });
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    VxBox()
                        .height(200)
                        .width(
                        mediaWidthSize,
                        )
                        .color(Colors.white) // 높이 설정
                        .withRounded(value: 20) // 양 옆 라운드 설정
                        .make(),
                    "맛집 위치는 바로 여기!"
                        .text
                        .size(bigFontSize + 2)
                        .fontWeight(FontWeight.w700)
                        .make()
                        .pOnly(top: 15, left: 20),
                    addressPopupWidget(addressNameText: addressNameText).pOnly(
                      top: 70,
                      left: 20,
                    ), // 마커 표시시 위치 정보가 보여 지는 팝업
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: mediaWidthSize - 40,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: baseColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                        builder: (context) => MarkerAddPage(
                                              gpsX: convertGPSY!,
                                              gpsY: convertGPSX!,
                                              placeAddress:
                                                  addressNameText!,
                                              uid: "aaa",
                                            )));
                              },
                              child: "이 위치로 지정하기".text.color(Colors.white).fontWeight(FontWeight.w700).make(),),),
                        
                      ],
                    ).pOnly(top: 150,left: 20),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class addressPopupWidget extends StatelessWidget {
  const addressPopupWidget({
    super.key,
    required this.addressNameText,
  });

  final String? addressNameText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VxBox()
            .color(Colors.grey[100]!)
            .height(50)
            .width(MediaQuery.of(context).size.width - 40).withRounded(value: 10)
            .make(),

        Center(child: "$addressNameText".text.size(addressFontSize).fontWeight(FontWeight.w700).make()).pOnly(top: 10)
      ],
    );
  }
}
