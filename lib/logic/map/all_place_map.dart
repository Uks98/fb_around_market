import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:fb_around_market/logic/map/map_marker_enum/marker_enum.dart';
import 'package:fb_around_market/logic/map/marker_detail_page/s_market_detail_page.dart';
import 'package:fb_around_market/logic/map/market_add_widgets/w_load_widget.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'convert_location.dart';
import 'location/s_user_location.dart';
import 'map_add_marker_page.dart';
import 'map_logic/map_logic.dart';
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

  Future<Position>? _locationFuture;
  Stream<QuerySnapshot> streamMapMarker() {
    return firestoreInit.collection("mapMarker").orderBy().snapshots();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //future 함수의 재귀를 막기 위해 변수에 대입
    _locationFuture = LocationClass().getLocation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _locationFuture,
        builder: (context,future) {
            if(future.connectionState == ConnectionState.waiting){
              return CustomLodeWidget.loadingWidget();
            }else if (future.hasError) {
              // 오류 발생 시
              return const Text("위치 정보를 불러오는 데 실패했습니다.");
            }else{
              final position = future.data!;
              NCameraPosition cameraPosition = NCameraPosition(
                target: NLatLng(position.latitude,position.longitude),
                zoom: 13,
                bearing: 45,
                tilt: 0,
              );
              return StreamBuilder(
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

                    final _latLng = NLatLng(position.latitude, position.longitude);
                    final _loadMarketLocation = NLatLng(double.parse(geoPointY.toString()), double.parse(geoPointX.toString()));
                    final distance = _latLng.distanceTo(_loadMarketLocation).round();


                    NMarker marker = NMarker(
                      icon: MarkerIcon.markerConvertWithMenu(markerData),
                      id: markerData["markerId"],
                      position: NLatLng(geoPointY, geoPointX,),
                    );
                    marker.setOnTapListener(
                          (overlay) => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) {
                              return MarketDetailPage(gpsX: geoPointX,gpsY: geoPointY,id : markerData["markerId"],uid : markerData["uid"],docId : doc.id, dayOfWeek: markerData["dayOfWeek"],
                                distance: distance,
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
                            nightModeEnable: true,
                              symbolScale: 1.2,
                              locationButtonEnable: true,
                              initialCameraPosition: cameraPosition
                          ),
                          onMapTapped: (x, y) {},
                          onMapReady: (controller1) {
                            naverMapController = controller1;
                            setState(() {
                              naverMapController!.addOverlayAll(markers!);
                            });

                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              items.isNotEmpty ? Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child:  CarouselSlider.builder(
                                  itemCount: snapshot.data?.docs.length,
                                  options: CarouselOptions(
                                    onPageChanged: (index, _){
                                      naverMapController?.updateCamera(
                                          NCameraUpdate.withParams(
                                            tilt: 0,
                                            zoom: 18,
                                            target: NLatLng(double.parse(items[index].gpsY.toString()), double.parse(items[index].gpsX.toString(),),),
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
                                    final position = future.data!;
                                    final latLng = NLatLng(position.latitude, position.longitude);
                                    final loadMarketLocation = NLatLng(double.parse(items[itemIndex].gpsY.toString()), double.parse(items[itemIndex].gpsX.toString()));
                                    final distance = latLng.distanceTo(loadMarketLocation).round();

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
                                                  "# ${items[itemIndex].categories.join().toString().replaceAll("(", "").replaceAll(")"," ")}".text.color(Colors.grey[400]).make(),
                                                  HeightBox(normalHeight),
                                                  "가게 이름 : ${items[itemIndex].marketName.toString()}".text.color(Colors.white).size(bigFontSize).fontWeight(FontWeight.w700).make(),
                                                  HeightBox(normalHeight),
                                                  "가게 위치 : ${items[itemIndex].locationName.toString()}".text.color(Colors.white).make(),
                                                  HeightBox(biggestHeight + 5),
                                                  "💬 리뷰 : 0개".text.color(Colors.white).make(),
                                                  HeightBox(smallHeight),
                                                  "📍 거리 : ${MapLogic.distanceConverter(distance)}".text.color(Colors.white).make(),
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
                  return CustomLodeWidget.loadingWidget();
                },
                stream: FirebaseFirestore.instance.collection("mapMarker").snapshots(),
              );
            }
        }
      ),
    );
  }
}
