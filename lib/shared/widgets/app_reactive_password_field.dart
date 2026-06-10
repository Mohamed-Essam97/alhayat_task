import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppReactivePasswordField extends HookWidget {
  const AppReactivePasswordField({
    super.key,
    required this.formControlName,
    required this.label,
  });

  final String formControlName;
  final String label;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);

    return ReactiveTextField<String>(
      formControlName: formControlName,
      obscureText: obscure.value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => obscure.value = !obscure.value,
        ),
      ),
      validationMessages: {
        ValidationMessage.required: (_) => '$label is required',
        ValidationMessage.minLength: (error) {
          final e = error as Map<String, dynamic>;
          return 'Minimum ${e['requiredLength']} characters';
        },
      },
    );
  }
}
