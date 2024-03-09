import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:ionicons/ionicons.dart';

import 'convert_location.dart';
import 'map_add_marker_page.dart';
import 'market_add_data/map_marker_data.dart';

class AllPlaceMapPage extends StatefulWidget {
  const AllPlaceMapPage({super.key});

  @override
  State<AllPlaceMapPage> createState() => _AllPlaceMapPageState();
}

class _AllPlaceMapPageState extends State<AllPlaceMapPage> {
  AddressName addressName = AddressName();
  NaverMapController? naverMapController;
  String? addressNameText = "";
  double? convertGPSX;
  double? convertGPSY;
  final user = FirebaseAuth.instance;



  Stream<QuerySnapshot> streamMapMarker() {
    final db = FirebaseFirestore.instance;
    return db.collection("mapMarker").snapshots();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
              .toList();

          Set<NMarker>? markers = snapshot.data?.docs.map((doc) {
            //final dummyx = doc.get("gpsX"); => stream방식 같으나 스트림 적용안됨
            final geoPointX = (doc.data())["gpsX"];
            final geoPointY = (doc.data())["gpsY"];
            NMarker marker = NMarker(
              id: doc.data()["markerId"],
              position: NLatLng(geoPointY, geoPointX),
            );
            marker.setOnTapListener(
              (overlay) => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MarkerAddPage(
                    uid: doc.data()["uid"],
                    docId: doc.id,
                    gpsX: geoPointX,
                    gpsY: geoPointY,
                    placeAddress: "",
                  ),
                ),
              ),
            );
            return marker;
          }).toSet();

          if (snapshot.hasData) {
            return Stack(
              children: [
                NaverMap(
                  options: const NaverMapViewOptions(),
                  onMapTapped: (x, y) {
                    // for(final i in teams){
                    //   final point = i
                    //   setState(() {
                    //     markers.add(NMarker(id: 'test3',position: NLatLng(i.reference., y.longitude)));
                    //     naverMapController?.addOverlayAll(markers);
                    //   });
                    // }
                  },
                  onMapReady: (controller1) {
                    naverMapController = controller1;
                    setState(() {
                      naverMapController!.addOverlayAll(markers!);
                    });

                    //markers!.map((e) => e.setOnTapListener((onMarkerInfoWindow) => print(onMarkerInfoWindow.position)));
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          color: Colors.grey,
                          child: ListView.builder(
                              itemCount: items!.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: GestureDetector(
                                      onTap: () {
                                        print(items[index].markerId);
                                      },
                                      child: Text(
                                        items[index].locationName.toString() ??
                                            "",
                                        style: const TextStyle(fontSize: 30),
                                      )),
                                );
                              })),
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
