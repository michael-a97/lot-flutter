import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'application/application.dart';
import 'config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final packageInfo = await PackageInfo.fromPlatform();
  AppConfig(version: packageInfo.version);
  await configureDependencies();
  runApp(const Application());
}
