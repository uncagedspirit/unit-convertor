import 'package:flutter/widgets.dart';

/// The two self-hosted font families (see pubspec.yaml / assets/fonts).
class AppFonts {
  const AppFonts._();
  static const fredoka = 'Fredoka';
  static const jakarta = 'Plus Jakarta Sans';
}

/// Rounded display font - used for titles, values, and headings, matching
/// the design's use of Fredoka.
TextStyle fredokaStyle({
  required double size,
  FontWeight weight = FontWeight.w600,
  Color? color,
  double? letterSpacing,
  double height = 1.1,
}) {
  return TextStyle(
    fontFamily: AppFonts.fredoka,
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

/// Body font - used for labels, subtitles, and secondary text.
TextStyle jakartaStyle({
  required double size,
  FontWeight weight = FontWeight.w500,
  Color? color,
  double? letterSpacing,
  double height = 1.3,
}) {
  return TextStyle(
    fontFamily: AppFonts.jakarta,
    fontSize: size,
    fontWeight: weight,
    color: color,
    letterSpacing: letterSpacing,
    height: height,
  );
}

/// The small all-caps section headers reused across Home/Converter/Settings
/// ("RECENT", "CONVERTS TO", "SIGNIFICANT FIGURES", ...).
TextStyle sectionLabelStyle(Color color) => jakartaStyle(
  size: 11,
  weight: FontWeight.w700,
  color: color,
  letterSpacing: 1.2,
);
