import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AppPasswordField extends HookWidget {
  const AppPasswordField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final obscure = useState(true);

    return TextField(
      controller: controller,
      obscureText: obscure.value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          ),
          onPressed: () => obscure.value = !obscure.value,
        ),
      ),
    );
  }
}
