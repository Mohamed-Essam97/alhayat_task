import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../features/auth/logic/auth_cubit.dart';
import '../../features/profile/logic/profile_cubit.dart';
import '../../features/tasks/logic/tasks_cubit.dart';

class AppBlocProviders {
  static List<BlocProvider> get providers => [
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider<TasksCubit>(
          create: (_) => getIt<TasksCubit>(),
        ),
        BlocProvider<ProfileCubit>(
          create: (_) => getIt<ProfileCubit>(),
        ),
      ];
}
