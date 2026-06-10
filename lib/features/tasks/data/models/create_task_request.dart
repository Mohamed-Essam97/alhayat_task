import 'package:json_annotation/json_annotation.dart';

part 'create_task_request.g.dart';

@JsonSerializable()
class CreateTaskRequest {
  const CreateTaskRequest({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTaskRequestToJson(this);
}
