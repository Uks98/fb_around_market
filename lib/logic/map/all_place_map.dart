import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:fb_around_market/logic/map/map_marker_enum/marker_enum.dart';
import 'package:fb_around_market/logic/map/marker_detail_page/s_market_detail_page.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

import 'convert_location.dart';
import 'map_add_marker_page.dart';
import 'market_add_data/map_marker_data.dart';

class AllPlaceMapPage extends StatefulWidget {
  const AllPlaceMapPage({super.key});

  @override
  State<AllPlaceMapPage> createState() => _AllPlaceMapPageState();
}

class _AllPlaceMapPageState extends State<AllPlaceMapPage> with FireBaseInitialize{
  AddressName addressName = AddressName();
  NaverMapController? naverMapController;
  String? addressNameText = "";
  double? convertGPSX;
  double? convertGPSY;
  final user = FirebaseAuth.instance;


  Stream<QuerySnapshot> streamMapMarker() {
    return firestoreInit.collection("mapMarker").snapshots();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  NCameraPosition cameraPosition = NCameraPosition(
    target: NLatLng(37.0222, 126.9783881),
    zoom: 18,
    bearing: 45,
    tilt: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        builder: (context, snapshot) {
          final items = snapshot.data?.docs
              .map(
                (e) => MarketData.fromJson(e.data())
                    .copyWith(markerId: e.data()["markerId"]),
              )
              .toList() ?? [];
          Set<NMarker>? markers = snapshot.data?.docs.map((doc) {
            //final dummyx = doc.get("gpsX"); => stream방식 같으나 스트림 적용안됨
            final markerData = doc.data();
            final geoPointX = (markerData)["gpsX"];
            final geoPointY = (markerData)["gpsY"];

            NMarker marker = NMarker(
              icon: MarkerIcon.markerConvertWithMenu(markerData),
              id: markerData["markerId"],
              position: NLatLng(geoPointY, geoPointX),
            );
            marker.setOnTapListener(
              (overlay) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return MarketDetailPage(gpsX: geoPointX,gpsY: geoPointY,id : markerData["markerId"],uid : markerData["uid"],docId : doc.id, dayOfWeek: markerData["dayOfWeek"],
                    //데이터 넘겨서 매칭 되는 요일만 색상 변경
                    );
                  }
                ),
              ),
            );
            return marker;
          }).toSet();

          if (snapshot.hasData) {

            return Stack(
              children: [
                NaverMap(

                  options:  NaverMapViewOptions(
                    initialCameraPosition: cameraPosition
                  ),
                  onMapTapped: (x, y) {},
                  onMapReady: (controller1) {
                    naverMapController = controller1;
                    setState(() {
                      naverMapController!.addOverlayAll(markers!);
                    });

                    markers!.map((e) => e.setOnTapListener((onMarkerInfoWindow) => print(onMarkerInfoWindow.position)));
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      items.isNotEmpty ?   Container(
                           width: MediaQuery.of(context).size.width,
                           color: Colors.transparent,
                           child:  CarouselSlider.builder(
                             itemCount: snapshot.data?.docs.length,
                               options: CarouselOptions(
                                 onPageChanged: (index, _){
                                   naverMapController?.updateCamera(
                                       NCameraUpdate.withParams(
                                         target: NLatLng(double.parse(items[index].gpsY.toString()), double.parse(items[index].gpsX.toString(),),),
                                         bearing: 180,
                                       )
                                   );
                                 },
                                 enableInfiniteScroll : false,
                                 autoPlay: false,
                                 height: 200,
                                 viewportFraction: 0.9,
                                 aspectRatio: 2.0,
                                 initialPage: 2,
                               ),
                             itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                               final mainSumImage = items[itemIndex].categoryImage.toString().replaceAll("(", "").replaceAll(")","");
                               return GestureDetector(
                                 onTap: (){

                                 },
                                 child: VxBox(child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Row(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       WidthBox(bigWidth),
                                       CircleAvatar(
                                         backgroundColor: cardColor,
                                         radius: 30,
                                         backgroundImage:AssetImage(mainSumImage),
                                       ).pOnly(top: biggestHeight),
                                       WidthBox(bigWidth),
                                       Column(
                                         mainAxisSize: MainAxisSize.min,
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           HeightBox(bigHeight),
                                           "# ${items[itemIndex].categories[0].toString()}".text.color(Colors.grey[400]).make(),
                                           HeightBox(normalHeight),
                                           "가게 이름 : ${items[itemIndex].marketName.toString()}".text.color(Colors.white).size(bigFontSize).fontWeight(FontWeight.w700).make(),
                                           HeightBox(normalHeight),
                                           "가게 위치 : ${items[itemIndex].locationName.toString()}".text.color(Colors.white).make(),
                                           HeightBox(biggestHeight + 5),
                                           "💬 리뷰 : 0개".text.color(Colors.white).make(),
                                         ],
                                       )
                                     ],
                                   ),

                                   HeightBox(biggestHeight),
                                 ],
                                                              ),).width(MediaQuery.of(context).size.width /1.2,).height(200).color(cardColor).withRounded(value: biggestHeight).make(),
                               );
                             },

                           ),
                       ) : Container(),
                      HeightBox(biggestHeight),
                    ],
                  ),
                )
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        stream: FirebaseFirestore.instance.collection("mapMarker").snapshots(),
      ),

    );
  }
}
