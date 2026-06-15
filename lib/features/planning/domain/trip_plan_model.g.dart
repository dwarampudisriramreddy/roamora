// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripPlanModel _$TripPlanModelFromJson(Map<String, dynamic> json) =>
    TripPlanModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => TripItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TripPlanModelToJson(TripPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'items': instance.items,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

TripItemModel _$TripItemModelFromJson(Map<String, dynamic> json) =>
    TripItemModel(
      id: json['id'] as String? ?? '',
      description: json['description'] as String?,
      locationAddress: json['locationAddress'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      date: json['date'] == null
          ? null
          : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$TripItemModelToJson(TripItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'locationAddress': instance.locationAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'date': instance.date?.toIso8601String(),
    };
