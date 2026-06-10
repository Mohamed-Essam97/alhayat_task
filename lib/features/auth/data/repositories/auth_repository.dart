import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_error_handler.dart';
import '../../../../core/storage/token_storage.dart';
import '../api/auth_api.dart';
import '../models/auth_response_model.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_model.dart';

@lazySingleton
class AuthRepository {
  AuthRepository(this._api, this._tokenStorage);

  final AuthApi _api;
  final TokenStorage _tokenStorage;

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.login(
        LoginRequest(email: email, password: password),
      );

      await _saveTokensIfPresent(response);
      return response;
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _api.register(
        RegisterRequest(name: name, email: email, password: password),
      );

      await _saveTokensIfPresent(response);
      return response;
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<UserModel> getProfile() async {
    try {
      return await _api.getProfile();
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<bool> hasToken() async {
    final token = await _tokenStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }

  Future<void> _saveTokensIfPresent(AuthResponseModel response) async {
    if (response.token.isNotEmpty && response.refreshToken.isNotEmpty) {
      await _tokenStorage.saveTokens(
        accessToken: response.token,
        refreshToken: response.refreshToken,
      );
    }
  }
}
