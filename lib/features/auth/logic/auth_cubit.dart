import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_result.dart';
import '../../../core/network/unauthorized_notifier.dart';
import '../data/repositories/auth_repository.dart';
import 'auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository, this._unauthorizedNotifier)
      : super(const AuthState()) {
    _unauthorizedNotifier.onUnauthorized = forceLogout;
  }

  final AuthRepository _repository;
  final UnauthorizedNotifier _unauthorizedNotifier;

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      if (!await _repository.hasToken()) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearUser: true,
            clearError: true,
          ),
        );
        return;
      }

      final user = await _repository.getProfile();

      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        ),
      );
    } on ApiException catch (e) {
      await _repository.logout();
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      await _repository.logout();
      emit(
        state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
        ),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final response = await _repository.login(email: email, password: password);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: response.user,
          clearError: true,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    try {
      final response = await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      if (response.token.isNotEmpty && response.refreshToken.isNotEmpty) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            user: response.user,
            clearError: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            clearError: true,
          ),
        );
      }
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: AuthStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(
      state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      ),
    );
  }

  void forceLogout() {
    logout();
  }
}
