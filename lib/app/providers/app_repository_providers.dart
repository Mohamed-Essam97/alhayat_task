import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/tasks/data/repositories/tasks_repository.dart';

class AppRepositoryProviders {
  static List<RepositoryProvider> get providers => [
        RepositoryProvider<AuthRepository>(
          create: (_) => getIt<AuthRepository>(),
        ),
        RepositoryProvider<TasksRepository>(
          create: (_) => getIt<TasksRepository>(),
        ),
      ];
}
