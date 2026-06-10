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
import 'register_screen.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final form = useMemoized(
      () => FormGroup({
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': FormControl<String>(
          validators: [Validators.required],
        ),
      }),
    );

    useEffect(() => form.dispose, [form]);

    void submit() {
      if (form.invalid) {
        form.markAllAsTouched();
        return;
      }

      context.read<AuthCubit>().login(
            email: (form.control('email').value as String).trim(),
            password: form.control('password').value as String,
          );
    }

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current.status == AuthStatus.error &&
              current.errorMessage != null,
          listener: (context, state) {
            AppSnackbar.error(context, state.errorMessage!);
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
                      Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to manage your tasks',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 32),
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
                        label: 'Login',
                        isLoading: isLoading,
                        onPressed: submit,
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterScreen(),
                                  ),
                                );
                              },
                        child: const Text('Create an account'),
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
