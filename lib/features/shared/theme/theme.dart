// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'spacing.dart';
export 'spacing.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF91CB3E);
  static const Color primaryDarkColor = Color(0xFF668e2b);
  static const Color lightGreyBackgroundColor = Color(0xFFf4f4f6);
}

final fontFamily = GoogleFonts.dmSans().fontFamily;
final _greyOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey.shade300),
  borderRadius: BorderRadius.circular(8),
);
final theme = ThemeData(
  primaryColor: AppColors.primaryColor,
  primaryColorDark: AppColors.primaryDarkColor,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: Colors.black,
    secondary: Colors.orange,
    onSecondary: Colors.black,
    error: Colors.red[700]!,
    onError: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  scaffoldBackgroundColor: AppColors.lightGreyBackgroundColor,
  fontFamily: fontFamily,
  appBarTheme: const AppBarTheme(
    color: AppColors.primaryColor,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: _greyOutlineInputBorder,
    enabledBorder: _greyOutlineInputBorder,
    focusedBorder: _greyOutlineInputBorder,
    activeIndicatorBorder: const BorderSide(
      color: AppColors.primaryColor,
      width: 3,
    ),
    disabledBorder: _greyOutlineInputBorder,
    suffixIconColor: Colors.grey,
    errorMaxLines: 2,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: fontFamily,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(vertical: Spacing.lg),
      elevation: 0,
    ),
  ),
);

extension ThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
}
