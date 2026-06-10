import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';
import 'refresh_token_service.dart';
import 'unauthorized_notifier.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required RefreshTokenService refreshTokenService,
    required UnauthorizedNotifier unauthorizedNotifier,
  })  : _dio = dio,
        _tokenStorage = tokenStorage,
        _refreshTokenService = refreshTokenService,
        _unauthorizedNotifier = unauthorizedNotifier;

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final RefreshTokenService _refreshTokenService;
  final UnauthorizedNotifier _unauthorizedNotifier;

  static const _retriedKey = 'retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isAuthPath(options.path)) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptRefresh(err)) {
      handler.next(err);
      return;
    }

    final options = err.requestOptions;

    if (options.extra[_retriedKey] == true) {
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Request already retried. Logging out.');
      }
      await _handleUnauthorized();
      handler.reject(err);
      return;
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] No refresh token available.');
      }
      await _handleUnauthorized();
      handler.reject(err);
      return;
    }

    if (kDebugMode) {
      debugPrint('[AuthInterceptor] Access token expired. Refreshing...');
    }

    final newAccessToken = await _refreshTokenService.refreshToken();

    if (newAccessToken == null || newAccessToken.isEmpty) {
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Refresh failed. Logging out.');
      }
      await _handleUnauthorized();
      handler.reject(err);
      return;
    }

    try {
      options.extra[_retriedKey] = true;
      options.headers['Authorization'] = 'Bearer $newAccessToken';

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Retrying ${options.method} ${options.path}');
      }

      final response = await _dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Retry failed: $e');
      }
      await _handleUnauthorized();
      handler.reject(err);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    if (err.response?.statusCode != 401) return false;
    if (_isAuthPath(err.requestOptions.path)) return false;
    if (err.requestOptions.extra[_retriedKey] == true) return false;
    return true;
  }

  bool _isAuthPath(String path) {
    return path.contains('/auth/login') ||
        path.contains('/auth/register') ||
        path.contains('/auth/refresh-token');
  }

  Future<void> _handleUnauthorized() async {
    await _tokenStorage.clearTokens();
    _unauthorizedNotifier.notify();
  }
}
