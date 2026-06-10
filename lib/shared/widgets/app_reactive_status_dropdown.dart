import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../features/tasks/data/models/task_model.dart';

class AppReactiveStatusDropdown extends StatelessWidget {
  const AppReactiveStatusDropdown({
    super.key,
    this.formControlName = 'status',
  });

  final String formControlName;

  @override
  Widget build(BuildContext context) {
    return ReactiveDropdownField<String>(
      formControlName: formControlName,
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: TaskStatus.values
          .map(
            (status) => DropdownMenuItem(
              value: status.toApi(),
              child: Text(status.label),
            ),
          )
          .toList(),
      validationMessages: {
        ValidationMessage.required: (_) => 'Status is required',
      },
    );
  }
}
