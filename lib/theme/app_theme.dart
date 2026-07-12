import 'package:flutter/material.dart';

import 'app_neutral_colors.dart';
import 'text_styles.dart';

ThemeData buildAppTheme({required Color seed, required Brightness brightness}) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  final neutrals = brightness == Brightness.dark
      ? AppNeutralColors.dark
      : AppNeutralColors.light;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: neutrals.scaffold,
    fontFamily: AppFonts.jakarta,
    extensions: [neutrals],
    splashFactory: InkRipple.splashFactory,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: neutrals.scaffold,
      selectedItemColor: neutrals.textPrimary,
      unselectedItemColor: neutrals.textTertiary,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
    ),
  );
}
