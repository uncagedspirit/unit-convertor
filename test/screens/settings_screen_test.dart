import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_converter/data/models/category.dart';
import 'package:unit_converter/screens/settings/settings_screen.dart';
import 'package:unit_converter/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppState> freshState() async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.loadFromPrefs();
    return state;
  }

  Widget harness(
    AppState state, {
    VoidCallback? onHowToUse,
    VoidCallback? onPrivacy,
    VoidCallback? onTerms,
  }) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        home: SettingsScreen(
          onOpenHowToUse: onHowToUse ?? () {},
          onOpenPrivacyPolicy: onPrivacy ?? () {},
          onOpenTerms: onTerms ?? () {},
        ),
      ),
    );
  }

  /// Settings has a lot of content - use a generously tall viewport so the
  /// whole scrollable list is built and visible without simulating scrolls
  /// for every single row under test.
  Future<void> useTallViewport(WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('shows every customization section', (tester) async {
    await useTallViewport(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    expect(find.text('ACCENT COLOR'), findsOneWidget);
    expect(find.text('THEME'), findsOneWidget);
    expect(find.text('CATEGORY CARD STYLE'), findsOneWidget);
    expect(find.text('SIGNIFICANT FIGURES'), findsOneWidget);
    expect(find.text('CARD ROUNDNESS'), findsOneWidget);
    expect(find.text('YOUR DATA'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('10 categories · 70 units'), findsOneWidget);
  });

  testWidgets('pink is selected by default', (tester) async {
    await useTallViewport(tester);
    final state = await freshState();
    expect(state.accentIndex, 0); // Pink
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });

  testWidgets('tapping an accent swatch changes AppState.accentIndex', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    // Tap the Purple swatch (index 7) via its semantics label - more
    // robust than a bare GestureDetector finder, which also matches
    // unrelated widgets (Slider, etc.) elsewhere on the screen.
    await tester.tap(find.bySemanticsLabel('Purple'));
    await tester.pumpAndSettle();

    expect(state.accentIndex, 7);
  });

  testWidgets('theme mode segments update AppState.themeMode', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    expect(state.themeMode, ThemeMode.system);
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();
    expect(state.themeMode, ThemeMode.dark);

    await tester.tap(find.text('Light'));
    await tester.pumpAndSettle();
    expect(state.themeMode, ThemeMode.light);
  });

  testWidgets('card style segments update AppState.paletteStyle', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    expect(state.paletteStyle, PaletteStyle.vivid);
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Muted'));
    await tester.pumpAndSettle();
    expect(state.paletteStyle, PaletteStyle.muted);
  });

  testWidgets('precision segments update AppState.precision', (tester) async {
    await useTallViewport(tester);
    final state = await freshState();
    expect(state.precision, 6);
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();
    expect(state.precision, 4);

    await tester.tap(find.text('8'));
    await tester.pumpAndSettle();
    expect(state.precision, 8);
  });

  testWidgets('behavior switches toggle their AppState fields', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    expect(state.grouping, isTrue);
    expect(state.showRecents, isTrue);
    expect(state.hapticsEnabled, isTrue);

    final switches = find.byType(Switch);
    expect(switches, findsNWidgets(3));

    await tester.tap(switches.at(0)); // Group thousands
    await tester.pumpAndSettle();
    expect(state.grouping, isFalse);

    await tester.tap(switches.at(1)); // Show recents
    await tester.pumpAndSettle();
    expect(state.showRecents, isFalse);

    await tester.tap(switches.at(2)); // Haptics
    await tester.pumpAndSettle();
    expect(state.hapticsEnabled, isFalse);
  });

  testWidgets('card roundness slider updates AppState.cornerRadius', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    expect(state.cornerRadius, 24);
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(Slider), const Offset(-100, 0));
    await tester.pumpAndSettle();

    expect(state.cornerRadius, isNot(24));
    expect(state.cornerRadius, inInclusiveRange(12, 32));
  });

  testWidgets('clear recents asks for confirmation before clearing', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    state.recordRecent('length');
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Clear recents'));
    await tester.pumpAndSettle();

    expect(find.text('Clear recents?'), findsOneWidget);
    expect(state.recents, isNotEmpty); // not cleared yet

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(state.recents, isNotEmpty); // cancel leaves it untouched

    await tester.tap(find.text('Clear recents'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clear'));
    await tester.pumpAndSettle();

    expect(state.recents, isEmpty);
  });

  testWidgets(
    'clear saved conversions asks for confirmation before clearing',
    (tester) async {
      await useTallViewport(tester);
      final state = await freshState();
      state.toggleFavorite('length|m|km');
      await tester.pumpWidget(harness(state));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clear saved conversions'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Clear'));
      await tester.pumpAndSettle();

      expect(state.favorites, isEmpty);
    },
  );

  testWidgets('reset settings restores defaults after confirmation', (
    tester,
  ) async {
    await useTallViewport(tester);
    final state = await freshState();
    state.setPrecision(4);
    state.setAccentIndex(5);
    await tester.pumpWidget(harness(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reset settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(state.precision, 6);
    expect(state.accentIndex, 0);
  });

  testWidgets('help and legal rows invoke their callbacks', (tester) async {
    await useTallViewport(tester);
    final state = await freshState();
    var howToUseCalled = false;
    var privacyCalled = false;
    var termsCalled = false;
    await tester.pumpWidget(
      harness(
        state,
        onHowToUse: () => howToUseCalled = true,
        onPrivacy: () => privacyCalled = true,
        onTerms: () => termsCalled = true,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('How to use this app'));
    await tester.tap(find.text('Privacy Policy'));
    await tester.tap(find.text('Terms of Use'));
    await tester.pumpAndSettle();

    expect(howToUseCalled, isTrue);
    expect(privacyCalled, isTrue);
    expect(termsCalled, isTrue);
  });
}
