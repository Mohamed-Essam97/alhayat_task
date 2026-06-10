import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/create_task_request.dart';
import '../models/task_model.dart';
import '../models/update_task_request.dart';

part 'tasks_api.g.dart';

@RestApi()
abstract class TasksApi {
  factory TasksApi(Dio dio, {String baseUrl}) = _TasksApi;

  @GET('/tasks')
  Future<List<TaskModel>> getTasks();

  @POST('/tasks')
  Future<TaskModel> createTask(@Body() CreateTaskRequest request);

  @PUT('/tasks/{id}')
  Future<TaskModel> updateTask(
    @Path('id') String id,
    @Body() UpdateTaskRequest request,
  );

  @DELETE('/tasks/{id}')
  Future<void> deleteTask(@Path('id') String id);
}
