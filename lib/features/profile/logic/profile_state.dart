import '../../auth/data/models/user_model.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.errorMessage,
  });

  final ProfileStatus status;
  final UserModel? user;
  final String? errorMessage;

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
