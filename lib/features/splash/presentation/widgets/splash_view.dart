import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:config/config.dart';
import 'package:flutter/material.dart';
import '../../../../config/config.dart';
import '../../../shared/shared.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      context.router.replace(const SignUpRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(child: Center(child: AnimatedAppLogo())),
            Text(AppConfig.instance.version),
          ],
        ),
      ),
    );
  }
}
