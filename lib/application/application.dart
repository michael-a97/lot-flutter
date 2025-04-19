import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../config/config.dart';
import '../features/shared/shared.dart';
import '../l10n/arb/app_localizations.dart';
import '../l10n/l10n.dart';
export 'application_bloc_observer.dart';

final appRouter = getIt<AppRouter>();

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
        GlobalKey<ScaffoldMessengerState>();
    return MaterialApp.router(
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => context.l10n.appName,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      theme: theme,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
    );
  }
}
