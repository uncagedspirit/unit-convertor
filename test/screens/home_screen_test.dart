import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_converter/data/category_data.dart';
import 'package:unit_converter/data/models/category.dart';
import 'package:unit_converter/screens/home/home_screen.dart';
import 'package:unit_converter/state/app_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<AppState> freshState() async {
    SharedPreferences.setMockInitialValues({});
    final state = AppState();
    await state.loadFromPrefs();
    return state;
  }

  Widget harness(AppState state, void Function(Category) onOpen) {
    return ChangeNotifierProvider.value(
      value: state,
      child: MaterialApp(home: HomeScreen(onOpenCategory: onOpen)),
    );
  }

  testWidgets('shows title, subtitle, and every category', (tester) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    expect(find.text('Unit Converter'), findsOneWidget);
    expect(find.text('Convert anything, instantly'), findsOneWidget);
    for (final cat in categories) {
      expect(find.text(cat.name), findsOneWidget);
    }
  });

  testWidgets('recents are hidden for a fresh install (no dummy data)', (
    tester,
  ) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    expect(find.text('RECENT'), findsNothing);
    expect(state.recents, isEmpty);
    expect(state.favorites, isEmpty);
  });

  testWidgets('search filters by category name', (tester) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'temp');
    await tester.pumpAndSettle();

    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('Length'), findsNothing);
  });

  testWidgets('search filters by unit symbol, not just category name', (
    tester,
  ) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'psi');
    await tester.pumpAndSettle();

    expect(find.text('Pressure'), findsOneWidget);
    expect(find.text('Length'), findsNothing);
  });

  testWidgets('search filters by unit name too (e.g. fahrenheit)', (
    tester,
  ) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'fahrenheit');
    await tester.pumpAndSettle();

    expect(find.text('Temperature'), findsOneWidget);
    expect(find.text('Length'), findsNothing);
  });

  testWidgets('unmatched search shows the no-results empty state', (
    tester,
  ) async {
    final state = await freshState();
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzz-nonexistent-unit');
    await tester.pumpAndSettle();

    expect(find.text('No matches found'), findsOneWidget);
  });

  testWidgets('tapping a category records a recent and opens it', (
    tester,
  ) async {
    final state = await freshState();
    Category? opened;
    await tester.pumpWidget(harness(state, (c) => opened = c));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Length'));
    await tester.pumpAndSettle();

    expect(opened?.id, 'length');
    expect(state.recents, ['length']);
    expect(find.text('RECENT'), findsOneWidget);
  });

  testWidgets('showRecents=false hides the section even with recents present', (
    tester,
  ) async {
    final state = await freshState();
    state.recordRecent('length');
    state.setShowRecents(false);
    await tester.pumpWidget(harness(state, (_) {}));
    await tester.pumpAndSettle();

    expect(find.text('RECENT'), findsNothing);
  });
}
