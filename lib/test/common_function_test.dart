
import 'package:fb_around_market/presentation/service/map_logic/map_logic.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../domain/map_marker_enum/marker_enum.dart';

void main(){
  String textChanger(String text){
    String changer = text .replaceAll("(", "").replaceAll(")", "");
    return changer;
  }

  test("textChanger",(){
    expect(textChanger("(HELLO)"),"HELLO");
  });
  //유저의 위치와 길거리 음식점의 거리를 km와 m로 변환해주는 함수 테스트
  test("distance test", () => expect(
      MapLogic.distanceConverter(23000021),"23000 km 21 m"
  ));

}