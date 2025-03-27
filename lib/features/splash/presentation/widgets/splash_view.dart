import 'package:flutter/material.dart';

import '../../../../config/config.dart';
import '../../../shared/shared.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

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
