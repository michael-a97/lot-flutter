import 'package:api/api.dart';
import 'package:config/config.dart';
import 'package:database/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:session_storage/session_storage.dart';

@module
abstract class DataModule {
  const DataModule();

  @lazySingleton
  AppDatabase appDatabase(
    @Named('dbPath') String dbPath, {
    @Named('debug') bool debug = false,
  }) {
    return AppDatabase.file(path: dbPath, enableLogging: debug);
  }

  @lazySingleton
  ApiClient apiClient({
    @Named('debug') bool debug = false,
    required SessionStorage sessionStorage,
  }) {
    return ApiClient.create(
      baseUrl: AppConfig.instance.baseHttpUrl,
      debug: debug,
      sessionStorage: sessionStorage,
    );
  }

  @lazySingleton
  FirebaseAuth firebaseAuth() {
    return FirebaseAuth.instance;
  }
}
