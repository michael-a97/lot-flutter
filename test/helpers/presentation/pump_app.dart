import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/l10n/arb/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: widget,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
