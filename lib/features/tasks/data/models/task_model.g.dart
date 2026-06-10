// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: TaskModel._idFromJson(json['id']),
      title: json['title'] as String,
      description: json['description'] as String,
      status: TaskModel._statusFromJson(json['status'] as String?),
      createdAt: TaskModel._dateFromJson(json['createdAt']),
      updatedAt: TaskModel._dateFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'status': TaskModel._statusToJson(instance.status),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
