// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTaskRequest _$UpdateTaskRequestFromJson(Map<String, dynamic> json) =>
    UpdateTaskRequest(
      title: json['title'] as String,
      description: json['description'] as String,
      status: UpdateTaskRequest._statusFromJson(json['status'] as String),
    );

Map<String, dynamic> _$UpdateTaskRequestToJson(UpdateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'status': UpdateTaskRequest._statusToJson(instance.status),
    };
