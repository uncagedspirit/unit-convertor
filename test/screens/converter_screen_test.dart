import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_converter/screens/converter/from_card.dart';
import 'package:unit_converter/screens/converter/converter_screen.dart';
import 'package:unit_converter/screens/converter/unit_chip_row.dart';
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
    required String categoryId,
    String? fromUnitId,
  }) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(
        home: ConverterScreen(
          categoryId: categoryId,
          initialFromUnitId: fromUnitId,
        ),
      ),
    );
  }

  /// The FROM card's big value display shares digits with the keypad's own
  /// number buttons (e.g. both can show "1"), so value assertions must be
  /// scoped to the FromCard widget specifically.
  Finder valueText(String value) =>
      find.descendant(of: find.byType(FromCard), matching: find.text(value));

  /// The default 800x600 test surface is a landscape-tablet shape, not a
  /// phone - use the design's own reference size so layout constraints
  /// match what a real device will actually provide.
  Future<void> usePhoneSize(WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 874);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('opens on the base unit with value 1 and shows other results', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state, categoryId: 'length'));
    await tester.pumpAndSettle();

    expect(find.text('Meter'), findsOneWidget); // FROM chip
    expect(valueText('1'), findsOneWidget);
    // The results list is scrollable, so only assert on rows near the top
    // that are guaranteed to be built without scrolling.
    expect(find.text('Millimeter'), findsOneWidget);
    expect(find.text('Kilometer'), findsOneWidget);
  });

  testWidgets('temperature opens on Celsius (no factor==1 unit exists)', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state, categoryId: 'temp'));
    await tester.pumpAndSettle();

    expect(find.text('Celsius'), findsOneWidget);
    // 1 degree C -> 33.8 F
    expect(find.text('33.8'), findsOneWidget);
  });

  testWidgets('typing on the keypad updates the value and live results', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state, categoryId: 'length'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('0')); // 1 -> "10"
    await tester.pumpAndSettle();

    expect(valueText('10'), findsOneWidget);
    // 10 m -> 10000 mm
    expect(find.text('10,000'), findsOneWidget);
  });

  testWidgets('backspace and clear both work', (tester) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state, categoryId: 'length'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.backspace_rounded));
    await tester.pumpAndSettle();
    expect(valueText('0'), findsOneWidget); // empty value displays as 0

    await tester.tap(find.text('5'));
    await tester.pumpAndSettle();
    expect(valueText('5'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(valueText('0'), findsOneWidget);
  });

  testWidgets('tapping a unit chip changes the from-unit, keeps the value', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state, categoryId: 'length'));
    await tester.pumpAndSettle();

    // "km" also appears as a result row's symbol subtitle, so scope the tap
    // to the unit chip row specifically.
    await tester.tap(
      find.descendant(
        of: find.byType(UnitChipRow),
        matching: find.text('km'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kilometer'), findsOneWidget); // now the FROM chip
    expect(valueText('1'), findsOneWidget); // value unchanged
    expect(find.text('Meter'), findsOneWidget); // meter is now a result row
  });

  testWidgets('tapping a result row swaps it in as the new from-unit', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(harness(state, categoryId: 'length'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Kilometer')); // swap onto km
    await tester.pumpAndSettle();

    expect(find.text('Kilometer'), findsOneWidget); // new FROM chip
    expect(valueText('0.001'), findsOneWidget); // 1m -> 0.001km
    expect(find.text('Meter'), findsOneWidget); // meter now a result row
  });

  testWidgets(
    'tapping the star favorites a specific pair without triggering swap',
    (tester) async {
      await usePhoneSize(tester);
      final state = await freshState();
      await tester.pumpWidget(harness(state, categoryId: 'length'));
      await tester.pumpAndSettle();

      expect(state.favorites, isEmpty);

      // Units are [mm,cm,m,km,in,ft,yd,mi,nmi]; with 'm' as the from-unit
      // excluded, the first result row is Millimeter.
      expect(find.text('Millimeter'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.star_border_rounded).first);
      await tester.pumpAndSettle();

      expect(state.favorites, ['length|m|mm']);
      // The from-unit must still be Meter - the star tap must not swap.
      expect(find.text('Meter'), findsOneWidget);
      expect(valueText('1'), findsOneWidget);

      // Tapping again un-favorites.
      await tester.tap(find.byIcon(Icons.star_rounded).first);
      await tester.pumpAndSettle();
      expect(state.favorites, isEmpty);
    },
  );

  testWidgets('opening with an explicit initial unit honors it', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    await tester.pumpWidget(
      harness(state, categoryId: 'length', fromUnitId: 'ft'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Foot'), findsOneWidget);
  });

  testWidgets('precision setting changes how many digits are shown', (
    tester,
  ) async {
    await usePhoneSize(tester);
    final state = await freshState();
    state.setPrecision(4);
    await tester.pumpWidget(harness(state, categoryId: 'length'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('2')); // value "1" -> "12"
    await tester.pumpAndSettle();
    // 12 m -> 12,000 mm at 4 sig figs (not 12,000.0... or extra digits)
    expect(find.text('12,000'), findsOneWidget);
  });
}
