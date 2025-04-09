import 'package:config/config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'application/application.dart';
import 'config/config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final packageInfo = await PackageInfo.fromPlatform();
  AppConfig(version: packageInfo.version, baseHttpUrl: 'http://10.0.2.2:8000');
  await configureDependencies();
  AppBlocObserver.init();
  runApp(const Application());
}
