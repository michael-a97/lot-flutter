//coverage:ignore-file
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'widgets/splash_view.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}
