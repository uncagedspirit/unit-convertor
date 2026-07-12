import 'package:flutter/material.dart';

/// Structural neutrals (backgrounds, subtle fills, text tones, dividers)
/// that stay independent of the accent seed color, ported from the design's
/// fixed grays (#221F1F text, #F1EBEF/#F5F1F3 fills, etc.), with a dark-mode
/// counterpart added since the original design was light-only.
@immutable
class AppNeutralColors extends ThemeExtension<AppNeutralColors> {
  const AppNeutralColors({
    required this.scaffold,
    required this.subtleFill,
    required this.subtleFillStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.divider,
  });

  final Color scaffold;
  final Color subtleFill;
  final Color subtleFillStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color divider;

  static const light = AppNeutralColors(
    scaffold: Color(0xFFFCFBFC),
    subtleFill: Color(0xFFF1EBEF),
    subtleFillStrong: Color(0xFFF5F1F3),
    textPrimary: Color(0xFF221F1F),
    textSecondary: Color(0xFF3A3537),
    textTertiary: Color(0xFF9A8E93),
    divider: Color(0xFFF1EAEE),
  );

  static const dark = AppNeutralColors(
    scaffold: Color(0xFF19171A),
    subtleFill: Color(0xFF2A272B),
    subtleFillStrong: Color(0xFF242226),
    textPrimary: Color(0xFFF2EDEF),
    textSecondary: Color(0xFFCFC6CB),
    textTertiary: Color(0xFF9E939A),
    divider: Color(0xFF322F33),
  );

  @override
  AppNeutralColors copyWith({
    Color? scaffold,
    Color? subtleFill,
    Color? subtleFillStrong,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? divider,
  }) {
    return AppNeutralColors(
      scaffold: scaffold ?? this.scaffold,
      subtleFill: subtleFill ?? this.subtleFill,
      subtleFillStrong: subtleFillStrong ?? this.subtleFillStrong,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppNeutralColors lerp(ThemeExtension<AppNeutralColors>? other, double t) {
    if (other is! AppNeutralColors) return this;
    return AppNeutralColors(
      scaffold: Color.lerp(scaffold, other.scaffold, t)!,
      subtleFill: Color.lerp(subtleFill, other.subtleFill, t)!,
      subtleFillStrong: Color.lerp(
        subtleFillStrong,
        other.subtleFillStrong,
        t,
      )!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

extension AppNeutralColorsX on BuildContext {
  AppNeutralColors get neutrals =>
      Theme.of(this).extension<AppNeutralColors>() ?? AppNeutralColors.light;
}
