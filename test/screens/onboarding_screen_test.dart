import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/screens/onboarding/onboarding_screen.dart';

void main() {
  Widget harness(VoidCallback onFinish) {
    return MaterialApp(home: OnboardingScreen(onFinish: onFinish));
  }

  testWidgets('starts on the welcome page', (tester) async {
    await tester.pumpWidget(harness(() {}));
    await tester.pumpAndSettle();

    expect(find.text('Welcome to Unit Converter'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next advances through all pages to Get Started', (
    tester,
  ) async {
    await tester.pumpWidget(harness(() {}));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Pick a category, type a number'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Save favorites, your way'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started on the last page calls onFinish', (tester) async {
    var finished = false;
    await tester.pumpWidget(harness(() => finished = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(finished, isTrue);
  });

  testWidgets('Skip calls onFinish immediately from the first page', (
    tester,
  ) async {
    var finished = false;
    await tester.pumpWidget(harness(() => finished = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(finished, isTrue);
  });
}
