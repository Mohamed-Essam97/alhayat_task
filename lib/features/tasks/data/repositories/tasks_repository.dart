import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_error_handler.dart';
import '../api/tasks_api.dart';
import '../models/create_task_request.dart';
import '../models/task_model.dart';
import '../models/update_task_request.dart';

@lazySingleton
class TasksRepository {
  TasksRepository(this._api);

  final TasksApi _api;

  Future<List<TaskModel>> getTasks() async {
    try {
      return await _api.getTasks();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<TaskModel> createTask({
    required String title,
    required String description,
  }) async {
    try {
      return await _api.createTask(
        CreateTaskRequest(title: title, description: description),
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<TaskModel> updateTask({
    required String id,
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    try {
      return await _api.updateTask(
        id,
        UpdateTaskRequest(
          title: title,
          description: description,
          status: status,
        ),
      );
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _api.deleteTask(id);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
