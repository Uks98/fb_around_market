// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_marker_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketDataImpl _$$MarketDataImplFromJson(Map<String, dynamic> json) =>
    _$MarketDataImpl(
      uid: json['uid'] as String?,
      markerId: json['markerId'] as String?,
      locationName: json['locationName'] as String?,
      marketName: json['marketName'] as String?,
      marketType: json['marketType'] as String?,
      kindOfCash: json['kindOfCash'] as String?,
      category: json['category'] as String?,
      placeName: json['placeName'] as String?,
      imagePath: json['imagePath'] as String?,
      gpsX: (json['gpsX'] as num?)?.toDouble(),
      gpsY: (json['gpsY'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MarketDataImplToJson(_$MarketDataImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'markerId': instance.markerId,
      'locationName': instance.locationName,
      'marketName': instance.marketName,
      'marketType': instance.marketType,
      'kindOfCash': instance.kindOfCash,
      'category': instance.category,
      'placeName': instance.placeName,
      'imagePath': instance.imagePath,
      'gpsX': instance.gpsX,
      'gpsY': instance.gpsY,
    };
