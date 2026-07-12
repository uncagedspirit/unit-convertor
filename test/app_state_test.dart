import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_converter/data/models/category.dart';
import 'package:unit_converter/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults before loading match design defaults', () {
    final state = AppState();
    expect(state.precision, 6);
    expect(state.grouping, true);
    expect(state.paletteStyle, PaletteStyle.vivid);
    expect(state.cornerRadius, 24);
    expect(state.accentIndex, 0);
    expect(state.hasSeenOnboarding, false);
    expect(state.recents, isEmpty);
    expect(state.favorites, isEmpty);
  });

  test('settings persist and reload across instances', () async {
    final state = AppState();
    await state.loadFromPrefs();

    state.setPrecision(8);
    state.setGrouping(false);
    state.setPaletteStyle(PaletteStyle.muted);
    state.setAccentIndex(3);
    state.setHasSeenOnboarding(true);

    final reloaded = AppState();
    await reloaded.loadFromPrefs();

    expect(reloaded.precision, 8);
    expect(reloaded.grouping, false);
    expect(reloaded.paletteStyle, PaletteStyle.muted);
    expect(reloaded.accentIndex, 3);
    expect(reloaded.hasSeenOnboarding, true);
  });

  test('recents are most-recent-first, deduplicated, capped at 6', () async {
    final state = AppState();
    await state.loadFromPrefs();

    for (final id in [
      'length',
      'mass',
      'temp',
      'volume',
      'area',
      'speed',
      'time',
    ]) {
      state.recordRecent(id);
    }
    // Re-opening 'mass' should jump it back to the front, not duplicate it.
    state.recordRecent('mass');

    expect(state.recents.length, 6);
    expect(state.recents.first, 'mass');
    expect(state.recents.where((id) => id == 'mass').length, 1);
  });

  test('favorites toggle on and off, keyed by category|from|to', () async {
    final state = AppState();
    await state.loadFromPrefs();
    const key = 'length|m|ft';

    expect(state.isFavorite(key), isFalse);
    state.toggleFavorite(key);
    expect(state.isFavorite(key), isTrue);
    state.toggleFavorite(key);
    expect(state.isFavorite(key), isFalse);
  });

  test(
    'resetSettings restores defaults without touching favorites/recents',
    () async {
      final state = AppState();
      await state.loadFromPrefs();

      state.setPrecision(4);
      state.setAccentIndex(5);
      state.recordRecent('length');
      state.toggleFavorite('length|m|ft');

      state.resetSettings();

      expect(state.precision, 6);
      expect(state.accentIndex, 0);
      expect(state.recents, ['length']);
      expect(state.isFavorite('length|m|ft'), isTrue);
    },
  );
}
