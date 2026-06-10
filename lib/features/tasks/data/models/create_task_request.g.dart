// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTaskRequest _$CreateTaskRequestFromJson(Map<String, dynamic> json) =>
    CreateTaskRequest(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CreateTaskRequestToJson(CreateTaskRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };
