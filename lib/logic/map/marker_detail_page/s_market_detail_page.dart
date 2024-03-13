import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/firs_base_mixin/fire_base_queue.dart';
import 'package:fb_around_market/logic/map/marker_detail_page/w_detail_widgets.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../image_compress.dart';
import '../market_add_data/map_marker_data.dart';
import '../market_add_widgets/button_widgets.dart';

class MarketDetailPage extends ConsumerStatefulWidget{
  double gpsX;
  double gpsY;
  String id;
  String uid;
  String docId;

  MarketDetailPage({super.key, required this.gpsX, required this.gpsY,required this.id,required this.uid,required this.docId});

  @override
  ConsumerState<MarketDetailPage> createState() => _MarketDetailPageConsumerState();
}

class _MarketDetailPageConsumerState extends ConsumerState<MarketDetailPage> with FireBaseInitialize {
  Stream<QuerySnapshot<Map<String,dynamic>>> streamMapData(){
    final mapData = firestoreInit.collection("mapMarker");
    return firestoreInit.collection("mapMarker").where("markerId",isEqualTo : widget.id).snapshots();
  }

  //유저의 프로필을 불러오는 stream입니다.
  Stream<QuerySnapshot<Map<String,dynamic>>> streamProfileInfo(){
    final users = fireBaseAuthInit.currentUser?.uid ?? "00";
    final myAddMarket = firestoreInit.collection("mapMarker").doc().get(); //마켓에 uid만 가져와서 users uid와 매치하는 이미지를 보여주자
    //final m = myAddMarket.
    return FirebaseFirestore.instance.collection("users").where("userUid",isEqualTo: widget.uid).snapshots();
  }
  Uint8List? _imageData;
  final ComplexImageLogicBox _imageCompress = ComplexImageLogicBox();
  String? profileImage;
  XFile? image;
  Future<void> saveUserProfileImage()async{
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref("marketImage/").child("${DateTime.now().microsecondsSinceEpoch}_${image?.name ?? "??"}.jpg");
    final compressImage =  await _imageCompress.imageCompressList(_imageData!);
    await storageRef.putData(compressImage);

    profileImage = await storageRef.getDownloadURL();
    
    await firestoreInit.collection("mapMarker").doc(widget.docId).update({
      "imagePath" : profileImage
    });
  }
  @override
  Widget build(BuildContext context) {

    final cameraPosition = NCameraPosition(
      target: NLatLng(widget.gpsY, widget.gpsX),
      zoom: 15,
      bearing: 45,
      tilt: 30,
    );
    final marker = NMarker(id: 'test4', position: NLatLng(widget.gpsY, widget.gpsX));
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFDFDFEFF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: streamMapData(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
               final marketData =  snapshot.data?.docs[0];
               final items = snapshot.data?.docs
                   .map(
                     (e) => MarketData.fromJson(e.data())
                     .copyWith(markerId: e.data()["markerId"]),
               )
                   .toList();

               return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HeightBox(50),
                    StreamBuilder(
                      stream: streamProfileInfo(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                           final userDataAdapter = snapshot.data?.docs;
                           final userData = userDataAdapter?.map((e) => e.data()["profileImage"]);
                          return Row(
                            children: [
                              //"${userData}".text.size(30).make(),
                              CircleAvatar(
                                radius: 40,
                               backgroundImage:NetworkImage(userData.toString().replaceAll("(", "").replaceAll(")","") ?? ""),
                              ),
                              WidthBox(normalWidth),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  "${userDataAdapter?.map((e) => e.data()["userId"])}님이 등록하셨어요.".text.color(greyFontColor).make(),
                                  HeightBox(smallHeight),
                                  "${marketData?["marketName"] == "" ? "매장 이름이 없어요!" : marketData?["marketName"]}"
                                      .text
                                      .fontWeight(FontWeight.w700)
                                      .size(biggestFontSize)
                                      .make(),
                                ],
                              ),
                            ],
                          ).pOnly(left: detailLeftRightPadding);
                        }
                        return Container();
                      }
                    ),
                    HeightBox(detailTopPadding),
                    VxBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          DetailIconText(
                            icons: Ionicons.aperture,
                            title: "즐겨찾기",
                            callBack: () {
                              print("${widget.uid}");
                            },
                          ),
                          DetailIconText(
                            icons: Ionicons.navigate_outline,
                            title: "길 안내",
                            callBack: () {},
                          ),
                          DetailIconText(
                            icons: Ionicons.pencil_outline,
                            title: "리뷰쓰기",
                            callBack: () {},
                          ),
                        ],
                      ).pOnly(top: 15),
                    )
                        .color(highGreyColor)
                        .width(mediaWidth - 50)
                        .height(80)
                        .withRounded(value: normalHeight)
                        .make()
                        .pOnly(left: 25),
                    HeightBox(detailTopPadding),
                    DetailMap(
                        mediaWidth: mediaWidth,
                        cameraPosition: cameraPosition,
                        marker: marker),
                    HeightBox(normalHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "가게 정보 & 메뉴"
                            .text
                            .color(greyFontColor)
                            .fontWeight(FontWeight.w700)
                            .size(bigFontSize)
                            .color(Colors.black)
                            .make(),
                        TextButtonWidget(buttonName: "정보 수정", callback: () {  },)
                      ],
                    ).pOnly(left: detailLeftRightPadding,right: detailLeftRightPadding),
                    HeightBox(normalHeight),
                    VxBox(
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MarketInfoWidget(intro: '도로명 주소',value:"${marketData?["locationName"]}",),
                            MarketInfoWidget(intro: '가게형태',value: "${marketData?["marketType"]}",),
                            MarketInfoWidget(intro: '결제방식',value: "현금",),
                            MarketInfoWidget(intro: '메뉴',value: "${marketData?["categories"]}",)
                          ],
                        )
                    )
                        .color(highGreyColor)
                        .width(mediaWidth - 50)
                        .height(150)
                        .withRounded(value: normalHeight)
                        .make()
                        .pOnly(left: 25),
                    HeightBox(detailTopPadding),
                    ///가게 사진
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "가게 사진"
                                .text
                                .color(greyFontColor)
                                .fontWeight(FontWeight.w700)
                                .size(bigFontSize)
                                .color(Colors.black)
                                .make(),
                            _imageData == null ? TextButtonWidget(buttonName: "사진 제보" , callback: () async{
                              ImagePicker imagePicker = ImagePicker();
                              final img = await imagePicker.pickImage(source: ImageSource.gallery);
                              _imageData = await img?.readAsBytes();
                              setState(() {});
                            },) : TextButtonWidget(buttonName: "사진 저장", callback: ()async{
                              await saveUserProfileImage();
                            }),
                          ],
                        ).pOnly(left: detailLeftRightPadding,right: detailLeftRightPadding),
                        HeightBox(smallHeight),
                        items?[0].imagePath == null ? VxBox(
                            child:Center(child: "📷 사진을 제보해주세요!".text.fontWeight(FontWeight.w700).size(bigFontSize).color(Colors.grey[500]).make())
                        )
                            .color(highGreyColor)
                            .width(mediaWidth - 50)
                            .height(120)
                            .withRounded(value: normalHeight)
                            .make()
                            .pOnly() : SizedBox(
                               width: 400,
                              height: 150,
                              child: ListView.builder(
                                  scrollDirection:Axis.horizontal,
                              itemCount: items?.length,
                              itemBuilder: (context,index){
                                return Container(
                                  width: 100,height: 100,
                                  //image path를 리스트로 변경하면 두장이상 가능
                                  child: Image.network(items?[index].imagePath.toString() ?? "",fit: BoxFit.cover,),);
                                                      }),
                            ),
                      ],
                    ),
                    HeightBox(detailTopPadding),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "리뷰"
                                .text
                                .color(greyFontColor)
                                .fontWeight(FontWeight.w700)
                                .size(bigFontSize)
                                .color(Colors.black)
                                .make(),
                            TextButtonWidget(buttonName: "리뷰 쓰기", callback: () {  },)
                          ],
                        ).pOnly(left: detailLeftRightPadding,right: detailLeftRightPadding),
                        HeightBox(smallHeight),
                        VxBox(
                            child:Center(child: "📷 리뷰를 작성해주세요!".text.fontWeight(FontWeight.w700).size(bigFontSize).color(Colors.grey[500]).make())
                        )
                            .color(highGreyColor)
                            .width(mediaWidth - 50)
                            .height(120)
                            .withRounded(value: normalHeight)
                            .make()
                            .pOnly(),
                      ],
                    ),
                    HeightBox(100),
                  ],
                );
              }
            return const Center(child: CircularProgressIndicator(),);
            }
          ),
        ),
      ),
    );
  }
}

class MarketInfoWidget extends StatelessWidget {
  String intro;
  String value;
   MarketInfoWidget({
    super.key,
     required this.intro,
     required this.value,

  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        intro.text.fontWeight(FontWeight.w700).size(normalFontSize).make().pOnly(left: 60),
        value.text.fontWeight(FontWeight.w700).size(normalFontSize).make().pOnly(right: 60),
      ],
    );
  }
}

class DetailMap extends StatelessWidget {
  const DetailMap({
    super.key,
    required this.mediaWidth,
    required this.cameraPosition,
    required this.marker,
  });

  final double mediaWidth;
  final NCameraPosition cameraPosition;
  final NMarker marker;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: mediaWidth - 50,
        height: 250,
        child: NaverMap(
          options: NaverMapViewOptions(
            initialCameraPosition: cameraPosition,
          ),
          onMapReady: (controller1) {
            controller1.addOverlay(marker);
            //print(marker);
          },
        ),
      ),
    );
  }
}
