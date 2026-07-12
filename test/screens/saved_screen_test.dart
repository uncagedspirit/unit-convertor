import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_converter/data/models/category.dart';
import 'package:unit_converter/screens/saved/saved_screen.dart';
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
    AppState state,
    void Function(Category category, String fromUnitId) onOpen,
  ) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(home: SavedScreen(onOpen: onOpen)),
    );
  }

  testWidgets('shows the empty state for a fresh install', (tester) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_, _) {}));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('renders a favorited pair with the correct converted value', (
    tester,
  ) async {
    final state = await freshState();
    state.toggleFavorite('length|m|km');
    await tester.pumpWidget(harness(state, (_, _) {}));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsNothing);
    expect(find.text('Length · m → km'), findsOneWidget);
    expect(find.text('1 m  =  0.001 km'), findsOneWidget);
  });

  testWidgets('tapping a row opens it with the right category and from-unit', (
    tester,
  ) async {
    final state = await freshState();
    state.toggleFavorite('temp|c|f');
    Category? openedCategory;
    String? openedFromUnit;
    await tester.pumpWidget(
      harness(state, (cat, fromUnitId) {
        openedCategory = cat;
        openedFromUnit = fromUnitId;
      }),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Temperature · °C → °F'));
    await tester.pumpAndSettle();

    expect(openedCategory?.id, 'temp');
    expect(openedFromUnit, 'c');
  });

  testWidgets('tapping the star removes the entry', (tester) async {
    final state = await freshState();
    state.toggleFavorite('length|m|km');
    await tester.pumpWidget(harness(state, (_, _) {}));
    await tester.pumpAndSettle();

    expect(find.text('Length · m → km'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.star_rounded));
    await tester.pumpAndSettle();

    expect(state.favorites, isEmpty);
    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('malformed favorite keys are skipped gracefully', (
    tester,
  ) async {
    final state = await freshState();
    state.toggleFavorite('not-a-valid-key');
    await tester.pumpWidget(harness(state, (_, _) {}));
    await tester.pumpAndSettle();

    // Nothing renderable, but no crash - falls back to the empty state.
    expect(find.text('Nothing saved yet'), findsOneWidget);
  });
}
