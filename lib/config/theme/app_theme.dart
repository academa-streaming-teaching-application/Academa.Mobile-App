import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFB300FF);
  static const Color secondaryColor = Color(0xFF2F2F2F);
  static const Color backgroundColor = Color(0xFF000000);
  static const Color errorColor = Color(0xFFD93F21);
  static const Color onLiveColor = Color(0xFFFFD500);
  static const Color profilePrimaryClassColor = Color(0xFF167EE6);

  ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'SFProDisplay',
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFFB300FF),
        secondary: secondaryColor,
        tertiary: profilePrimaryClassColor,
        error: errorColor,
        surface: backgroundColor,
        onPrimary: Colors.white,
      ),
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w100,
        ),
      ),
      cupertinoOverrideTheme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(fontFamily: ''),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
      ),
    );
  }
}
