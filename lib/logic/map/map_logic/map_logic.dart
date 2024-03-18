
class MapLogic{
  ///해당 유저의 위치와 길거리 음식점의 거리를 km와 m로 변환해주는 함수입니다.
  static String distanceConverter(int distance) {
    int km = distance ~/ 1000; // 소수점 버리고 정수만 반환
    int m = distance % 1000;

    if (km > 0) {
      return "$km km $m m";
    } else {
      return "$m m";
    }
  }
}