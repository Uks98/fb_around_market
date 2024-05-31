
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

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