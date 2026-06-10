import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_error_view.dart';
import '../../../shared/widgets/app_loading_view.dart';
import '../../auth/logic/auth_cubit.dart';
import '../logic/profile_cubit.dart';
import '../logic/profile_state.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<ProfileCubit>().loadProfile();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const AppLoadingView();
          }

          if (state.status == ProfileStatus.error) {
            return AppErrorView(
              message: state.errorMessage ?? 'Failed to load profile',
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            );
          }

          final user = state.user;
          if (user == null) {
            return const AppErrorView(message: 'No profile data');
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  radius: 36,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(height: 24),
                _ProfileField(label: 'Name', value: user.name),
                const SizedBox(height: 16),
                _ProfileField(label: 'Email', value: user.email),
                const Spacer(),
                AppButton(
                  label: 'Logout',
                  icon: Icons.logout,
                  onPressed: () => context.read<AuthCubit>().logout(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}
