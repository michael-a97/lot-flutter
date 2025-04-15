// coverage:ignore-file
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_storage/secure_storage.dart';

import '../config.dart';
export 'dependency_injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  final path = (await getApplicationDocumentsDirectory()).path;
  getIt.registerSingleton<String>(path, instanceName: 'dbPath');
  getIt.registerSingleton<bool>(kDebugMode, instanceName: 'debug');
  getIt.registerSingleton<Storage>(SecureStorage());
  await getIt.init();
}
