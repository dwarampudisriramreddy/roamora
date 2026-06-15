import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

enum DiscoveryMode {
  all,
  womenOnly,
  mine,
}

@JsonSerializable()
class UserModel {
  @JsonKey(defaultValue: '')
  final String uid;
  @JsonKey(defaultValue: '')
  final String email;
  final String? photoURL;
  final bool isVerified;
  final double trustScore;
  final List<String> interests;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final String? gender;

  UserModel({
    required this.uid,
    required this.email,
    this.photoURL,
    this.isVerified = false,
    this.trustScore = 0.0,
    this.interests = const [],
    this.latitude,
    this.longitude,
    this.createdAt,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoURL: json['photoURL'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      trustScore: (json['trustScore'] as num?)?.toDouble() ?? 0.0,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .where((e) => e.isNotEmpty)
              .toList() ??
          const [],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      createdAt: json['createdAt'] is String
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      gender: json['gender'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? uid,
    String? email,
    String? photoURL,
    bool? isVerified,
    double? trustScore,
    List<String>? interests,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    String? gender,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      isVerified: isVerified ?? this.isVerified,
      trustScore: trustScore ?? this.trustScore,
      interests: interests ?? this.interests,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      gender: gender ?? this.gender,
    );
  }
}
