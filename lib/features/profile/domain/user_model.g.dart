// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  uid: json['uid'] as String? ?? '',
  email: json['email'] as String? ?? '',
  photoURL: json['photoURL'] as String?,
  isVerified: json['isVerified'] as bool? ?? false,
  trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0.0,
  interests:
      (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  latitude: (json['latitude'] as num?)?.toDouble(),
  longitude: (json['longitude'] as num?)?.toDouble(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  gender: json['gender'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'photoURL': instance.photoURL,
  'isVerified': instance.isVerified,
  'trustScore': instance.trustScore,
  'interests': instance.interests,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'createdAt': instance.createdAt?.toIso8601String(),
  'gender': instance.gender,
};
