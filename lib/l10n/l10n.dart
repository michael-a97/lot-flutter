import 'package:flutter/material.dart';

import 'arb/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension AppLocalizationsXX on AppLocalizations {
  String formattedOtpTimeoutDuration(Duration duration) {
    final formattedHour = twoDigits(duration.inMinutes);
    final twoDigitMinutes = twoDigits(duration.inSeconds.remainder(60));
    final formattedMinute = twoDigitMinutes;
    return '$formattedHour:$formattedMinute';
  }

  String twoDigits(int number) => number.toString().padLeft(2, '0');
}
