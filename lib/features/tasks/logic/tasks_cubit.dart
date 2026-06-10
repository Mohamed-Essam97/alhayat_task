import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_result.dart';
import '../data/models/task_model.dart';
import '../data/repositories/tasks_repository.dart';
import 'tasks_state.dart';

@lazySingleton
class TasksCubit extends Cubit<TasksState> {
  TasksCubit(this._repository) : super(const TasksState());

  final TasksRepository _repository;

  Future<void> getTasks() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final tasks = await _repository.getTasks();
      emit(
        state.copyWith(
          tasks: tasks,
          isLoading: false,
          clearError: true,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<bool> createTask({
    required String title,
    required String description,
  }) async {
    emit(state.copyWith(isCreating: true, clearError: true));

    try {
      final task = await _repository.createTask(
        title: title,
        description: description,
      );
      emit(
        state.copyWith(
          tasks: [task, ...state.tasks],
          isCreating: false,
          clearError: true,
        ),
      );
      return true;
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          isCreating: false,
          errorMessage: e.message,
        ),
      );
      return false;
    }
  }

  Future<bool> updateTask({
    required String id,
    required String title,
    required String description,
    required TaskStatus status,
  }) async {
    emit(state.copyWith(isUpdating: true, clearError: true));

    try {
      final updatedTask = await _repository.updateTask(
        id: id,
        title: title,
        description: description,
        status: status,
      );

      final tasks = state.tasks
          .map((task) => task.id == id ? updatedTask : task)
          .toList();

      emit(
        state.copyWith(
          tasks: tasks,
          isUpdating: false,
          clearError: true,
        ),
      );
      return true;
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          isUpdating: false,
          errorMessage: e.message,
        ),
      );
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    emit(state.copyWith(isDeleting: true, clearError: true));

    try {
      await _repository.deleteTask(id);
      emit(
        state.copyWith(
          tasks: state.tasks.where((task) => task.id != id).toList(),
          isDeleting: false,
          clearError: true,
        ),
      );
      return true;
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          isDeleting: false,
          errorMessage: e.message,
        ),
      );
      return false;
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}
