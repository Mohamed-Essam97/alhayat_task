import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../storage/token_storage.dart';

@lazySingleton
class RefreshTokenService {
  RefreshTokenService(
    @Named('refreshDio') this._refreshDio,
    this._tokenStorage,
  );

  final Dio _refreshDio;
  final TokenStorage _tokenStorage;

  Future<String?>? _refreshFuture;

  Future<String?> refreshToken() {
    _refreshFuture ??= _performRefresh();
    return _refreshFuture!;
  }

  Future<String?> _performRefresh() async {
    try {
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _tokenStorage.clearTokens();
        return null;
      }

      if (kDebugMode) {
        debugPrint('[RefreshTokenService] Refreshing access token...');
      }

      final response = await _refreshDio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      final data = _unwrapResponse(response.data);
      final newAccessToken = data?['accessToken'] as String?;
      final newRefreshToken = data?['refreshToken'] as String?;

      if (newAccessToken == null ||
          newAccessToken.isEmpty ||
          newRefreshToken == null ||
          newRefreshToken.isEmpty) {
        await _tokenStorage.clearTokens();
        return null;
      }

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      if (kDebugMode) {
        debugPrint('[RefreshTokenService] Token refresh succeeded.');
      }

      return newAccessToken;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[RefreshTokenService] Token refresh failed: $e');
      }
      await _tokenStorage.clearTokens();
      return null;
    } finally {
      _refreshFuture = null;
    }
  }

  Map<String, dynamic>? _unwrapResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'] as Map<String, dynamic>;
      }
      return data;
    }
    return null;
  }
}
