import 'package:flutter/widgets.dart';

import 'unit.dart';

/// The two card-color variants exposed as a user setting (ported from the
/// design's `palette` prop).
enum PaletteStyle { muted, vivid }

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.example,
    required this.colorMuted,
    required this.colorVivid,
    required this.units,
  });

  final String id;
  final String name;
  final IconData icon;
  final String example;
  final Color colorMuted;
  final Color colorVivid;
  final List<ConvertibleUnit> units;

  Color colorFor(PaletteStyle style) =>
      style == PaletteStyle.vivid ? colorVivid : colorMuted;

  /// Whether search text matches this category's name, or any of its
  /// units' names/symbols (case-insensitive substring match).
  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    if (name.toLowerCase().contains(q)) return true;
    return units.any(
      (u) =>
          u.name.toLowerCase().contains(q) || u.symbol.toLowerCase().contains(q),
    );
  }
}
