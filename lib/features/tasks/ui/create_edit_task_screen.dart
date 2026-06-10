import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_reactive_status_dropdown.dart';
import '../../../shared/widgets/app_reactive_text_field.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../data/models/task_model.dart';
import '../logic/tasks_cubit.dart';
import '../logic/tasks_state.dart';

class CreateEditTaskScreen extends HookWidget {
  const CreateEditTaskScreen({super.key, this.task});

  final TaskModel? task;

  bool get isEditing => task != null;

  @override
  Widget build(BuildContext context) {
    final form = useMemoized(
      () => FormGroup({
        'title': FormControl<String>(
          value: task?.title ?? '',
          validators: [Validators.required],
        ),
        'description': FormControl<String>(
          value: task?.description ?? '',
          validators: [Validators.required],
        ),
        'status': FormControl<String>(
          value: task?.status.toApi() ?? 'Pending',
          validators: [Validators.required],
        ),
      }),
      [task?.id],
    );

    useEffect(() => form.dispose, [form]);

    Future<void> submit() async {
      if (form.invalid) {
        form.markAllAsTouched();
        return;
      }

      final cubit = context.read<TasksCubit>();
      final title = (form.control('title').value as String).trim();
      final description = (form.control('description').value as String).trim();

      final success = isEditing
          ? await cubit.updateTask(
              id: task!.id,
              title: title,
              description: description,
              status: TaskStatus.fromApi(
                form.control('status').value as String,
              ),
            )
          : await cubit.createTask(
              title: title,
              description: description,
            );

      if (!context.mounted) return;

      if (success) {
        AppSnackbar.success(
          context,
          isEditing ? 'Task updated' : 'Task created',
        );
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listenWhen: (previous, current) => current.errorMessage != null,
        listener: (context, state) {
          if (state.errorMessage != null) {
            AppSnackbar.error(context, state.errorMessage!);
            context.read<TasksCubit>().clearError();
          }
        },
        builder: (context, state) {
          final isSubmitting =
              isEditing ? state.isUpdating : state.isCreating;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ReactiveForm(
              formGroup: form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppReactiveTextField(
                    formControlName: 'title',
                    label: 'Title',
                  ),
                  const SizedBox(height: 16),
                  const AppReactiveTextField(
                    formControlName: 'description',
                    label: 'Description',
                    maxLines: 4,
                  ),
                  if (isEditing) ...[
                    const SizedBox(height: 16),
                    AppReactiveStatusDropdown(
                      formControlName: 'status',
                    ),
                  ],
                  const SizedBox(height: 24),
                  AppButton(
                    label: isEditing ? 'Save Changes' : 'Create Task',
                    isLoading: isSubmitting,
                    onPressed: submit,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
