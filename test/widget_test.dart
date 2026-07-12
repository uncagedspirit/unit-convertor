import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unit_converter/app.dart';
import 'package:unit_converter/state/app_state.dart';

void main() {
  testWidgets('a fresh install shows onboarding, not Home', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const UnitConverterApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome to Unit Converter'), findsOneWidget);
    expect(find.text('Unit Converter'), findsNothing);
  });

  testWidgets('once onboarding is done, the app shows the Home tab', (
    WidgetTester tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    appState.setHasSeenOnboarding(true);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const UnitConverterApp(),
      ),
    );
    await tester.pump();

    expect(find.text('Unit Converter'), findsOneWidget);
  });

  testWidgets('Settings links open the real Privacy/Terms/How-to-use screens', (
    WidgetTester tester,
  ) async {
    // Settings has a lot of content - use a tall viewport so the HELP/ABOUT
    // rows are built without needing to simulate scrolling.
    tester.view.physicalSize = const Size(402, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    final appState = AppState();
    await appState.loadFromPrefs();
    appState.setHasSeenOnboarding(true);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: appState,
        child: const UnitConverterApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('How to use this app'));
    await tester.pumpAndSettle();
    expect(find.text('Find a category'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Firebase Analytics'), findsWidgets);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terms of Use'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Accuracy disclaimer'), findsOneWidget);
  });
}
