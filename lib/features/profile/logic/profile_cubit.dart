import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/network/api_result.dart';
import '../../auth/data/repositories/auth_repository.dart';
import 'profile_state.dart';

@lazySingleton
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository) : super(const ProfileState());

  final AuthRepository _authRepository;

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading, clearError: true));

    try {
      final user = await _authRepository.getProfile();
      emit(
        state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          clearError: true,
        ),
      );
    } on ApiException catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.error,
          errorMessage: e.message,
        ),
      );
    }
  }
}
