import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/category.dart';
import 'prefs_keys.dart';

/// The single source of truth for user settings, favorites, and recents.
/// Call [loadFromPrefs] once (awaited, before runApp) so the first frame
/// already reflects persisted state - every setter below assumes that has
/// already happened.
class AppState extends ChangeNotifier {
  late SharedPreferences _prefs;

  int _precision = 6;
  bool _grouping = true;
  PaletteStyle _paletteStyle = PaletteStyle.vivid;
  double _cornerRadius = 24;
  bool _showRecents = true;
  int _accentIndex = 0;
  ThemeMode _themeMode = ThemeMode.system;
  bool _hapticsEnabled = true;
  List<String> _recents = [];
  List<String> _favorites = [];
  bool _hasSeenOnboarding = false;

  int get precision => _precision;
  bool get grouping => _grouping;
  PaletteStyle get paletteStyle => _paletteStyle;
  double get cornerRadius => _cornerRadius;
  bool get showRecents => _showRecents;
  int get accentIndex => _accentIndex;
  ThemeMode get themeMode => _themeMode;
  bool get hapticsEnabled => _hapticsEnabled;
  List<String> get recents => List.unmodifiable(_recents);
  List<String> get favorites => List.unmodifiable(_favorites);
  bool get hasSeenOnboarding => _hasSeenOnboarding;

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    _precision = prefs.getInt(PrefsKeys.precision) ?? 6;
    _grouping = prefs.getBool(PrefsKeys.grouping) ?? true;
    _paletteStyle = prefs.getString(PrefsKeys.paletteStyle) == 'muted'
        ? PaletteStyle.muted
        : PaletteStyle.vivid;
    _cornerRadius = prefs.getDouble(PrefsKeys.cornerRadius) ?? 24;
    _showRecents = prefs.getBool(PrefsKeys.showRecents) ?? true;
    _accentIndex = prefs.getInt(PrefsKeys.accentIndex) ?? 0;
    _themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == prefs.getString(PrefsKeys.themeMode),
      orElse: () => ThemeMode.system,
    );
    _hapticsEnabled = prefs.getBool(PrefsKeys.hapticsEnabled) ?? true;
    _recents = prefs.getStringList(PrefsKeys.recents) ?? [];
    _favorites = prefs.getStringList(PrefsKeys.favorites) ?? [];
    _hasSeenOnboarding = prefs.getBool(PrefsKeys.hasSeenOnboarding) ?? false;
  }

  void _save(String key, Object value) {
    switch (value) {
      case final int v:
        _prefs.setInt(key, v);
      case final bool v:
        _prefs.setBool(key, v);
      case final double v:
        _prefs.setDouble(key, v);
      case final String v:
        _prefs.setString(key, v);
      case final List<String> v:
        _prefs.setStringList(key, v);
    }
  }

  void setPrecision(int value) {
    _precision = value;
    notifyListeners();
    _save(PrefsKeys.precision, value);
  }

  void setGrouping(bool value) {
    _grouping = value;
    notifyListeners();
    _save(PrefsKeys.grouping, value);
  }

  void setPaletteStyle(PaletteStyle value) {
    _paletteStyle = value;
    notifyListeners();
    _save(PrefsKeys.paletteStyle, value.name);
  }

  void setCornerRadius(double value) {
    _cornerRadius = value;
    notifyListeners();
    _save(PrefsKeys.cornerRadius, value);
  }

  void setShowRecents(bool value) {
    _showRecents = value;
    notifyListeners();
    _save(PrefsKeys.showRecents, value);
  }

  void setAccentIndex(int value) {
    _accentIndex = value;
    notifyListeners();
    _save(PrefsKeys.accentIndex, value);
  }

  void setThemeMode(ThemeMode value) {
    _themeMode = value;
    notifyListeners();
    _save(PrefsKeys.themeMode, value.name);
  }

  void setHapticsEnabled(bool value) {
    _hapticsEnabled = value;
    notifyListeners();
    _save(PrefsKeys.hapticsEnabled, value);
  }

  void setHasSeenOnboarding(bool value) {
    _hasSeenOnboarding = value;
    notifyListeners();
    _save(PrefsKeys.hasSeenOnboarding, value);
  }

  /// Records a category as recently opened: most-recent-first, deduplicated,
  /// capped at 6 - matches the design's recents behavior exactly.
  void recordRecent(String categoryId) {
    _recents = [
      categoryId,
      ..._recents.where((id) => id != categoryId),
    ].take(6).toList();
    notifyListeners();
    _save(PrefsKeys.recents, _recents);
  }

  void clearRecents() {
    _recents = [];
    notifyListeners();
    _save(PrefsKeys.recents, _recents);
  }

  bool isFavorite(String key) => _favorites.contains(key);

  /// [key] is the composite `categoryId|fromUnitId|toUnitId` triple - a
  /// finer granularity than [recents], which is category-only.
  void toggleFavorite(String key) {
    _favorites = _favorites.contains(key)
        ? _favorites.where((k) => k != key).toList()
        : [..._favorites, key];
    notifyListeners();
    _save(PrefsKeys.favorites, _favorites);
  }

  void clearFavorites() {
    _favorites = [];
    notifyListeners();
    _save(PrefsKeys.favorites, _favorites);
  }

  /// Resets customization settings to defaults. Recents/favorites/onboarding
  /// are left untouched - those are cleared/set independently.
  void resetSettings() {
    _precision = 6;
    _grouping = true;
    _paletteStyle = PaletteStyle.vivid;
    _cornerRadius = 24;
    _showRecents = true;
    _accentIndex = 0;
    _themeMode = ThemeMode.system;
    _hapticsEnabled = true;
    notifyListeners();
    _prefs
      ..remove(PrefsKeys.precision)
      ..remove(PrefsKeys.grouping)
      ..remove(PrefsKeys.paletteStyle)
      ..remove(PrefsKeys.cornerRadius)
      ..remove(PrefsKeys.showRecents)
      ..remove(PrefsKeys.accentIndex)
      ..remove(PrefsKeys.themeMode)
      ..remove(PrefsKeys.hapticsEnabled);
  }
}
