import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trip_plan_model.g.dart';

@JsonSerializable()
class TripPlanModel {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String userId;
  @JsonKey(defaultValue: '')
  final String title;
  final List<TripItemModel> items;
  final DateTime? createdAt;

  TripPlanModel({
    required this.id,
    required this.userId,
    required this.title,
    this.items = const [],
    this.createdAt,
  });

  factory TripPlanModel.fromJson(Map<String, dynamic> json) {
    return TripPlanModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((e) => TripItemModel.fromJson(e))
              .toList() ??
          [],
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => _$TripPlanModelToJson(this);

  TripPlanModel copyWith({
    String? id,
    String? userId,
    String? title,
    List<TripItemModel>? items,
    DateTime? createdAt,
  }) {
    return TripPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

@JsonSerializable()
class TripItemModel {
  @JsonKey(defaultValue: '')
  final String id;
  final String? description;
  final String? locationAddress;
  @JsonKey(defaultValue: 0.0)
  final double latitude;
  @JsonKey(defaultValue: 0.0)
  final double longitude;
  final DateTime? date;

  TripItemModel({
    required this.id,
    this.description,
    this.locationAddress,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.date,
  });

  factory TripItemModel.fromJson(Map<String, dynamic> json) {
    try {
      return TripItemModel(
        id: json['id'] as String? ?? '',
        description: json['description'] as String?,
        locationAddress: json['locationAddress'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        date: json['date'] is String ? DateTime.tryParse(json['date'] as String) : null,
      );
    } catch (e, stack) {
      debugPrint('CRITICAL: TripItemModel.fromJson failed!');
      debugPrint('Error: $e');
      debugPrint('JSON data: $json');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$TripItemModelToJson(this);
}
