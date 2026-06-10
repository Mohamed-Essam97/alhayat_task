import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  @JsonKey(fromJson: _idFromJson)
  final String id;
  final String name;
  final String email;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  static String _idFromJson(dynamic value) => value?.toString() ?? '';
}
