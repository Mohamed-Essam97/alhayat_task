import 'package:json_annotation/json_annotation.dart';

import 'task_model.dart';

part 'update_task_request.g.dart';

@JsonSerializable()
class UpdateTaskRequest {
  const UpdateTaskRequest({
    required this.title,
    required this.description,
    required this.status,
  });

  final String title;
  final String description;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final TaskStatus status;

  factory UpdateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTaskRequestToJson(this);

  static TaskStatus _statusFromJson(String value) => TaskStatus.fromApi(value);

  static String _statusToJson(TaskStatus status) => status.toApi();
}
