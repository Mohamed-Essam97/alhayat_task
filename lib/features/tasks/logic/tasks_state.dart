import '../data/models/task_model.dart';

class TasksState {
  const TasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.isDeleting = false,
    this.errorMessage,
  });

  final List<TaskModel> tasks;
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final bool isDeleting;
  final String? errorMessage;

  TasksState copyWith({
    List<TaskModel>? tasks,
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
