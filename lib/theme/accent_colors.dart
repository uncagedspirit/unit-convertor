import 'package:flutter/widgets.dart';

/// A selectable accent color, used as the seed for the app's Material 3
/// [ColorScheme]. Independent from the per-category card palette
/// ([PaletteStyle]) - changing this never affects category card colors.
class AccentColor {
  const AccentColor({required this.name, required this.seed});

  final String name;
  final Color seed;
}

/// Pink is first/default per the user's explicit requirement.
const List<AccentColor> accentColors = [
  AccentColor(name: 'Pink', seed: Color(0xFFEC4899)),
  AccentColor(name: 'Red', seed: Color(0xFFEF4444)),
  AccentColor(name: 'Orange', seed: Color(0xFFFB923C)),
  AccentColor(name: 'Yellow', seed: Color(0xFFF5B400)),
  AccentColor(name: 'Green', seed: Color(0xFF22C55E)),
  AccentColor(name: 'Teal', seed: Color(0xFF14B8A6)),
  AccentColor(name: 'Blue', seed: Color(0xFF3B82F6)),
  AccentColor(name: 'Purple', seed: Color(0xFFA855F7)),
];

const defaultAccentIndex = 0;
