/// SharedPreferences key names. Prefixed with a version so a future format
/// change can migrate cleanly instead of silently misreading old data.
class PrefsKeys {
  const PrefsKeys._();

  static const precision = 'v1.precision';
  static const grouping = 'v1.grouping';
  static const paletteStyle = 'v1.paletteStyle';
  static const cornerRadius = 'v1.cornerRadius';
  static const showRecents = 'v1.showRecents';
  static const accentIndex = 'v1.accentIndex';
  static const themeMode = 'v1.themeMode';
  static const hapticsEnabled = 'v1.hapticsEnabled';
  static const recents = 'v1.recents';
  static const favorites = 'v1.favorites';
  static const hasSeenOnboarding = 'v1.hasSeenOnboarding';
}
