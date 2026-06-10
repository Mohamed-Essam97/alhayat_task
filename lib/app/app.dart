import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/logic/auth_cubit.dart';
import '../features/auth/logic/auth_state.dart';
import '../features/auth/ui/login_screen.dart';
import '../features/tasks/ui/task_list_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          switch (state.status) {
            case AuthStatus.initial:
            case AuthStatus.loading:
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            case AuthStatus.authenticated:
              return const TaskListScreen();
            case AuthStatus.unauthenticated:
            case AuthStatus.error:
              return const LoginScreen();
          }
        },
      ),
    );
  }
}
