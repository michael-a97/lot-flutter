// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:data/data.dart' as _i437;
import 'package:data/src/di/di.module.dart' as _i359;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lot/config/router/router.dart' as _i489;
import 'package:lot/features/phone_number_verification/application/phone_number_verification_cubit.dart'
    as _i619;
import 'package:lot/features/sign_in/application/sign_in_cubit.dart' as _i465;
import 'package:lot/features/sign_up/application/sign_up_cubit.dart' as _i795;
import 'package:session_storage/src/di/di.module.dart' as _i397;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    await _i359.DataPackageModule().init(gh);
    await _i397.SessionStoragePackageModule().init(gh);
    gh.factory<_i795.SignUpCubit>(
      () => _i795.SignUpCubit(gh<_i437.AccountRepository>()),
    );
    gh.factory<_i489.AppRouter>(
      () => _i489.AppRouter(gh<_i437.AuthenticationRepository>()),
    );
    gh.factory<_i465.SignInCubit>(
      () => _i465.SignInCubit(gh<_i437.AuthenticationRepository>()),
    );
    gh.factory<_i619.PhoneNumberVerificationCubit>(
      () => _i619.PhoneNumberVerificationCubit(
        gh<_i437.AuthenticationRepository>(),
      ),
    );
    return this;
  }
}
