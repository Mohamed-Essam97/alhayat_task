import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bloc_providers.dart';
import 'app_repository_providers.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: AppRepositoryProviders.providers,
      child: MultiBlocProvider(
        providers: AppBlocProviders.providers,
        child: child,
      ),
    );
  }
}
