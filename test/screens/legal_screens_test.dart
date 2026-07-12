import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/screens/help/how_to_use_screen.dart';
import 'package:unit_converter/screens/legal/privacy_policy_screen.dart';
import 'package:unit_converter/screens/legal/terms_screen.dart';

/// The user's real email must never appear in shipped legal copy - only
/// the clearly-marked placeholder, which they fill in before publishing.
const _realDeveloperEmail = 'saakshik15@gmail.com';

void main() {
  /// These screens are long-form text - use a tall viewport so every
  /// section (including the last, "Contact us") is built without needing
  /// to simulate a scroll.
  Future<void> useTallViewport(WidgetTester tester) async {
    tester.view.physicalSize = const Size(402, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('How to use shows all 5 numbered steps', (tester) async {
    await useTallViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: HowToUseScreen()));
    await tester.pumpAndSettle();

    expect(find.text('How to use this app'), findsOneWidget);
    expect(find.text('Find a category'), findsOneWidget);
    expect(find.text('Customize the app'), findsOneWidget);
    expect(find.text('5'), findsOneWidget); // last step number badge
  });

  testWidgets(
    'Privacy Policy discloses Firebase Analytics usage in plain language',
    (tester) async {
      await useTallViewport(tester);
      await tester.pumpWidget(const MaterialApp(home: PrivacyPolicyScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.textContaining('Firebase Analytics'), findsWidgets);
      expect(find.textContaining('anonymous'), findsWidgets);
      expect(find.textContaining(supportContactEmail), findsOneWidget);
    },
  );

  testWidgets('Privacy Policy states the advertising ID is not collected', (
    tester,
  ) async {
    await useTallViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: PrivacyPolicyScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Advertising ID'), findsOneWidget);
    expect(find.textContaining('no ads'), findsWidgets);
  });

  testWidgets('Privacy Policy never contains the real developer email', (
    tester,
  ) async {
    await useTallViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: PrivacyPolicyScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining(_realDeveloperEmail), findsNothing);
  });

  testWidgets('Terms of Use includes an accuracy disclaimer', (tester) async {
    await useTallViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: TermsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Terms of Use'), findsOneWidget);
    expect(find.textContaining('Accuracy disclaimer'), findsOneWidget);
    expect(find.textContaining(supportContactEmail), findsOneWidget);
  });

  testWidgets('Terms of Use never contains the real developer email', (
    tester,
  ) async {
    await useTallViewport(tester);
    await tester.pumpWidget(const MaterialApp(home: TermsScreen()));
    await tester.pumpAndSettle();

    expect(find.textContaining(_realDeveloperEmail), findsNothing);
  });
}
