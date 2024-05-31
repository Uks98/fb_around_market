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
      kindOfCash: (json['kindOfCash'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          const [],
      categoryImage: json['categoryImage'] as String?,
      imagePath: json['imagePath'] as String?,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          const [],
      dayOfWeek: (json['dayOfWeek'] as List<dynamic>?)
              ?.map((e) => e as String?)
              .toList() ??
          const [],
      gpsX: (json['gpsX'] as num?)?.toDouble(),
      gpsY: (json['gpsY'] as num?)?.toDouble(),
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$MarketDataImplToJson(_$MarketDataImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'markerId': instance.markerId,
      'locationName': instance.locationName,
      'marketName': instance.marketName,
      'marketType': instance.marketType,
      'kindOfCash': instance.kindOfCash,
      'categoryImage': instance.categoryImage,
      'imagePath': instance.imagePath,
      'categories': instance.categories,
      'dayOfWeek': instance.dayOfWeek,
      'gpsX': instance.gpsX,
      'gpsY': instance.gpsY,
      'distance': instance.distance,
    };
