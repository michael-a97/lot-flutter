import 'package:flutter/material.dart';

import '../config/config.dart';
import '../features/shared/shared.dart';

final appRouter = getIt<AppRouter>();

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
      theme: theme,
    );
  }
}
