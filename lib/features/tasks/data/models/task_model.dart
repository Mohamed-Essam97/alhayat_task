import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

enum TaskStatus {
  pending,
  inProgress,
  completed;

  static TaskStatus fromApi(String? value) {
    switch (value) {
      case 'In Progress':
        return TaskStatus.inProgress;
      case 'Completed':
        return TaskStatus.completed;
      case 'Pending':
      default:
        return TaskStatus.pending;
    }
  }

  String toApi() {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  String get label => toApi();
}

@JsonSerializable()
class TaskModel {
  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(fromJson: _idFromJson)
  final String id;
  final String title;
  final String description;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final TaskStatus status;
  @JsonKey(fromJson: _dateFromJson)
  final DateTime? createdAt;
  @JsonKey(fromJson: _dateFromJson)
  final DateTime? updatedAt;

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: _idFromJson(json['id']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: _statusFromJson(json['status'] as String?),
      createdAt: _dateFromJson(json['createdAt'] ?? json['created_at']),
      updatedAt: _dateFromJson(json['updatedAt'] ?? json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static String _idFromJson(dynamic value) => value?.toString() ?? '';

  static TaskStatus _statusFromJson(String? value) => TaskStatus.fromApi(value);

  static String _statusToJson(TaskStatus status) => status.toApi();

  static DateTime? _dateFromJson(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
