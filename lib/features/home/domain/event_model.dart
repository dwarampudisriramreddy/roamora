import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel {
  @JsonKey(defaultValue: '')
  final String id;
  @JsonKey(defaultValue: '')
  final String hostId;
  @JsonKey(defaultValue: '')
  final String reason;
  final String? locationAddress;
  final double latitude;
  final double longitude;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> participants;

  EventModel({
    required this.id,
    required this.hostId,
    required this.reason,
    this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.startTime,
    required this.endTime,
    this.participants = const [],
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    try {
      return EventModel(
        id: json['id'] as String? ?? '',
        hostId: json['hostId'] as String? ?? '',
        reason: json['reason'] as String? ?? '',
        locationAddress: json['locationAddress'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        startTime: json['startTime'] is String
            ? (DateTime.tryParse(json['startTime'] as String) ?? DateTime.now())
            : DateTime.now(),
        endTime: json['endTime'] is String
            ? (DateTime.tryParse(json['endTime'] as String) ?? DateTime.now())
            : DateTime.now(),
        participants: (json['participants'] as List<dynamic>?)
                ?.map((e) => e?.toString() ?? '')
                .where((e) => e.isNotEmpty)
                .toList() ??
            const [],
      );
    } catch (e, stack) {
      debugPrint('CRITICAL: EventModel.fromJson failed!');
      debugPrint('Error: $e');
      debugPrint('JSON data: $json');
      debugPrint('Stack trace: $stack');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  EventModel copyWith({
    String? id,
    String? hostId,
    String? reason,
    String? locationAddress,
    double? latitude,
    double? longitude,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? participants,
  }) {
    return EventModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      reason: reason ?? this.reason,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      participants: participants ?? this.participants,
    );
  }
}
