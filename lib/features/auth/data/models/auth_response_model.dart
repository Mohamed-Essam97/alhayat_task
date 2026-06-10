import 'package:json_annotation/json_annotation.dart';

import 'user_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel {
  const AuthResponseModel({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  final String token;
  final String refreshToken;
  final UserModel user;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return AuthResponseModel(
      token: data['token'] as String? ?? data['accessToken'] as String? ?? '',
      refreshToken: data['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(
        data['user'] as Map<String, dynamic>? ?? data,
      ),
    );
  }

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);
}
