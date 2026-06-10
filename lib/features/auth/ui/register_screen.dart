import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_reactive_password_field.dart';
import '../../../shared/widgets/app_reactive_text_field.dart';
import '../../../shared/widgets/app_snackbar.dart';
import '../logic/auth_cubit.dart';
import '../logic/auth_state.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useMemoized(
      () => FormGroup({
        'name': FormControl<String>(
          validators: [Validators.required],
        ),
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': FormControl<String>(
          validators: [Validators.required, Validators.minLength(6)],
        ),
      }),
    );

    useEffect(() => form.dispose, [form]);

    void submit() {
      if (form.invalid) {
        form.markAllAsTouched();
        return;
      }

      context.read<AuthCubit>().register(
            name: (form.control('name').value as String).trim(),
            email: (form.control('email').value as String).trim(),
            password: form.control('password').value as String,
          );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current.status == AuthStatus.error ||
              current.status == AuthStatus.unauthenticated,
          listener: (context, state) {
            if (state.status == AuthStatus.error &&
                state.errorMessage != null) {
              AppSnackbar.error(context, state.errorMessage!);
              return;
            }

            if (state.status == AuthStatus.unauthenticated) {
              AppSnackbar.success(
                context,
                'Account created. Please login.',
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ReactiveForm(
                  formGroup: form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppReactiveTextField(
                        formControlName: 'name',
                        label: 'Name',
                      ),
                      const SizedBox(height: 16),
                      const AppReactiveTextField(
                        formControlName: 'email',
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const AppReactivePasswordField(
                        formControlName: 'password',
                        label: 'Password',
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Register',
                        isLoading: isLoading,
                        onPressed: submit,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
