import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_marker_data.freezed.dart';
part 'map_marker_data.g.dart';

@freezed
sealed class MarketData with _$MarketData{
  factory MarketData({
    String? uid,
    String? markerId,
    String? locationName,
    String? marketName,
    String? marketType,
    @Default([]) List<String?>  kindOfCash, //결제 형태
    String? categoryImage,
    String? imagePath,
    @Default([]) List<String?> categories,
    @Default([]) List<String?> dayOfWeek,

    double? gpsX,
    double? gpsY,
    int? distance,
  }) = _MarketData;
  factory MarketData.fromJson(Map<String,dynamic> json ) => _$MarketDataFromJson(json);
}