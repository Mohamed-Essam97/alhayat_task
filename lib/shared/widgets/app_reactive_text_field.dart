import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppReactiveTextField extends StatelessWidget {
  const AppReactiveTextField({
    super.key,
    required this.formControlName,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  final String formControlName;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: formControlName,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validationMessages: {
        ValidationMessage.required: (_) => '$label is required',
        ValidationMessage.email: (_) => 'Enter a valid email',
        ValidationMessage.minLength: (error) {
          final e = error as Map<String, dynamic>;
          return 'Minimum ${e['requiredLength']} characters';
        },
      },
    );
  }
}
