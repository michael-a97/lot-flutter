//@GeneratedMicroModule;DataPackageModule;package:data/src/di/di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:api/api.dart' as _i24;
import 'package:data/src/account/repository/account_repository.dart' as _i555;
import 'package:data/src/auth/repository/authentication_repository.dart'
    as _i195;
import 'package:data/src/di/module/data_module.dart' as _i73;
import 'package:database/database.dart' as _i252;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:injectable/injectable.dart' as _i526;

class DataPackageModule extends _i526.MicroPackageModule {
  // initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final dataModule = _$DataModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => dataModule.firebaseAuth());
    gh.factory<_i195.AuthenticationRepository>(
      () => _i195.AuthenticationRepositoryImpl(gh<_i59.FirebaseAuth>()),
    );
    gh.lazySingleton<_i24.ApiClient>(
      () => dataModule.apiClient(debug: gh<bool>(instanceName: 'debug')),
    );
    gh.lazySingleton<_i252.AppDatabase>(
      () => dataModule.appDatabase(
        gh<String>(instanceName: 'dbPath'),
        debug: gh<bool>(instanceName: 'debug'),
      ),
    );
    gh.factory<_i555.AccountRepository>(
      () => _i555.AccountRepositoryImpl(
        gh<_i24.ApiClient>(),
        gh<_i252.AppDatabase>(),
        gh<_i59.FirebaseAuth>(),
      ),
    );
  }
}

class _$DataModule extends _i73.DataModule {}
