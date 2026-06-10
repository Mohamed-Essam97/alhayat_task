import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/api/auth_api.dart';
import '../../features/tasks/data/api/tasks_api.dart';
import '../network/dio_factory.dart';
import '../network/refresh_token_service.dart';
import '../network/unauthorized_notifier.dart';
import '../storage/token_storage.dart';

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @Named('refreshDio')
  @lazySingleton
  Dio refreshDio() => DioFactory.createRefreshDio();

  @lazySingleton
  Dio dio(
    TokenStorage tokenStorage,
    RefreshTokenService refreshTokenService,
    UnauthorizedNotifier unauthorizedNotifier,
  ) {
    return DioFactory.createAppDio(
      tokenStorage: tokenStorage,
      refreshTokenService: refreshTokenService,
      unauthorizedNotifier: unauthorizedNotifier,
    );
  }

  @lazySingleton
  AuthApi authApi(Dio dio) => AuthApi(dio);

  @lazySingleton
  TasksApi tasksApi(Dio dio) => TasksApi(dio);
}
