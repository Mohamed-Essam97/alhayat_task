// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:alhayat_task/core/di/register_module.dart' as _i742;
import 'package:alhayat_task/core/network/refresh_token_service.dart' as _i182;
import 'package:alhayat_task/core/network/unauthorized_notifier.dart' as _i412;
import 'package:alhayat_task/core/storage/token_storage.dart' as _i613;
import 'package:alhayat_task/features/auth/data/api/auth_api.dart' as _i490;
import 'package:alhayat_task/features/auth/data/repositories/auth_repository.dart'
    as _i733;
import 'package:alhayat_task/features/auth/logic/auth_cubit.dart' as _i795;
import 'package:alhayat_task/features/profile/logic/profile_cubit.dart'
    as _i576;
import 'package:alhayat_task/features/tasks/data/api/tasks_api.dart' as _i351;
import 'package:alhayat_task/features/tasks/data/repositories/tasks_repository.dart'
    as _i843;
import 'package:alhayat_task/features/tasks/logic/tasks_cubit.dart' as _i721;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i412.UnauthorizedNotifier>(
        () => _i412.UnauthorizedNotifier());
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.refreshDio(),
      instanceName: 'refreshDio',
    );
    gh.lazySingleton<_i613.TokenStorage>(
        () => _i613.TokenStorage(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i182.RefreshTokenService>(() => _i182.RefreshTokenService(
          gh<_i361.Dio>(instanceName: 'refreshDio'),
          gh<_i613.TokenStorage>(),
        ));
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio(
          gh<_i613.TokenStorage>(),
          gh<_i182.RefreshTokenService>(),
          gh<_i412.UnauthorizedNotifier>(),
        ));
    gh.lazySingleton<_i490.AuthApi>(
        () => registerModule.authApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i351.TasksApi>(
        () => registerModule.tasksApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i733.AuthRepository>(() => _i733.AuthRepository(
          gh<_i490.AuthApi>(),
          gh<_i613.TokenStorage>(),
        ));
    gh.lazySingleton<_i843.TasksRepository>(
        () => _i843.TasksRepository(gh<_i351.TasksApi>()));
    gh.lazySingleton<_i795.AuthCubit>(() => _i795.AuthCubit(
          gh<_i733.AuthRepository>(),
          gh<_i412.UnauthorizedNotifier>(),
        ));
    gh.lazySingleton<_i576.ProfileCubit>(
        () => _i576.ProfileCubit(gh<_i733.AuthRepository>()));
    gh.lazySingleton<_i721.TasksCubit>(
        () => _i721.TasksCubit(gh<_i843.TasksRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i742.RegisterModule {}
