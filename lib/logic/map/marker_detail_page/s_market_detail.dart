import 'package:fb_around_market/color/color_box.dart';
import 'package:fb_around_market/logic/map/marker_detail_page/w_detail_widgets.dart';
import 'package:fb_around_market/size_valiable/utill_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

class MarketDetailPage extends StatelessWidget {
  double gpsX;
  double gpsY;

  MarketDetailPage({super.key, required this.gpsX, required this.gpsY});

  @override
  Widget build(BuildContext context) {
    final cameraPosition = NCameraPosition(
      target: NLatLng(gpsY, gpsX),
      zoom: 15,
      bearing: 45,
      tilt: 30,
    );
    final marker = NMarker(id: 'test4', position: NLatLng(gpsY, gpsX));
    final mediaWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "와사비땅콩님의 제보".text.color(greyFontColor).make(),
            HeightBox(normalHeight),
            "범호 오뎅"
                .text
                .fontWeight(FontWeight.w700)
                .size(biggestFontSize)
                .make(),
            VxBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DetailIconText(
                    icons: Ionicons.aperture,
                    title: "즐겨찾기",
                    callBack: () {},
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
              ).pOnly(top: 25),
            )
                .color(highGreyColor)
                .width(mediaWidth - 50)
                .height(100)
                .withRounded(value: biggestHeight)
                .make()
                .pOnly(left: 25),
            detailMap(
                mediaWidth: mediaWidth,
                cameraPosition: cameraPosition,
                marker: marker),
            "가게 정보 & 메뉴"
                .text
                .color(greyFontColor)
                .fontWeight(FontWeight.w700)
                .size(bigFontSize)
                .color(Colors.black)
                .make(),
            //클래스화 하기
            TextButton(
                onPressed: () {},
                child: "정보 수정"
                    .text
                    .color(baseColor)
                    .fontWeight(FontWeight.w700).fontWeight(FontWeight.bold)
                    .make()
                    .pOnly(),),
            VxBox(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MarketInfoWidget(intro: '가게형태',value: "편의점",),
                  MarketInfoWidget(intro: '결제방식',value: "현금",),
                  MarketInfoWidget(intro: '메뉴',value: "타코야끼",)
                ],
              ) 
            )
                .color(highGreyColor)
                .width(mediaWidth - 50)
                .height(150)
                .withRounded(value: biggestHeight)
                .make()
                .pOnly(left: 25),

          ],
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
        intro.text.fontWeight(FontWeight.w700).size(bigFontSize).make().pOnly(left: 60),
        value.text.fontWeight(FontWeight.w700).size(bigFontSize).make().pOnly(right: 60),
      ],
    );
  }
}

class detailMap extends StatelessWidget {
  const detailMap({
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
