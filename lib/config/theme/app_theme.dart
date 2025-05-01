import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFC070E3);
  static const Color secondaryColor = Color(0xFF2B2A2A);
  static const Color backgroundColor = Color(0xFF161616);
  static const Color errorColor = Color(0xFFD93F21);
  static const Color onLiveColor = Color(0xFFFFD500);
  static const Color profilePrimaryClassColor = Color(0xFF167EE6);

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Boogaloo',
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: profilePrimaryClassColor,
          error: errorColor,
          surface: backgroundColor,
          onPrimary: Colors.white),
    );
  }
}
