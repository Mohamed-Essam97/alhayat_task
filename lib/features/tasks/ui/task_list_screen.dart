import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../shared/widgets/app_empty_state.dart';
import '../../../shared/widgets/app_loading_view.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../../../shared/widgets/app_status_badge.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../profile/ui/profile_screen.dart';
import '../data/models/task_model.dart';
import '../logic/tasks_cubit.dart';
import '../logic/tasks_state.dart';
import 'create_edit_task_screen.dart';

class TaskListScreen extends HookWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<TasksCubit>().getTasks();
      return null;
    }, const []);

    Future<void> confirmDelete(TaskModel task) async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete task'),
          content: Text('Are you sure you want to delete "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (shouldDelete != true || !context.mounted) return;

      final success = await context.read<TasksCubit>().deleteTask(task.id);
      if (!context.mounted) return;

      if (success) {
        AppSnackbar.success(context, 'Task deleted');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            tooltip: 'Profile',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listenWhen: (previous, current) =>
            current.errorMessage != null && !current.isDeleting,
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppSnackbar.error(context, state.errorMessage!);
            context.read<TasksCubit>().clearError();
          }
        },
        builder: (context, state) {
          if (state.isLoading && state.tasks.isEmpty) {
            return const AppLoadingView();
          }

          if (state.tasks.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => context.read<TasksCubit>().getTasks(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 80),
                  AppEmptyState(
                    icon: Icons.task_alt,
                    title: 'No tasks yet',
                    subtitle: 'Pull down to refresh or create a new task',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => context.read<TasksCubit>().getTasks(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            AppStatusBadge(status: task.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(task.description),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: state.isDeleting
                                  ? null
                                  : () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CreateEditTaskScreen(task: task),
                                        ),
                                      );
                                    },
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Edit'),
                            ),
                            TextButton.icon(
                              onPressed: state.isDeleting
                                  ? null
                                  : () => confirmDelete(task),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CreateEditTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
