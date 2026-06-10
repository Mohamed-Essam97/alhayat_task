import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'refresh_token_service.dart';
import 'unauthorized_notifier.dart';

class DioFactory {
  static BaseOptions get _baseOptions => BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

  static Dio createRefreshDio() {
    return Dio(_baseOptions);
  }

  static Dio createAppDio({
    required TokenStorage tokenStorage,
    required RefreshTokenService refreshTokenService,
    required UnauthorizedNotifier unauthorizedNotifier,
  }) {
    final dio = Dio(_baseOptions);

    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        tokenStorage: tokenStorage,
        refreshTokenService: refreshTokenService,
        unauthorizedNotifier: unauthorizedNotifier,
      ),
    );

    return dio;
  }
}
