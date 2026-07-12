import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/navigation/root_shell.dart';
import 'package:unit_converter/navigation/tab_item.dart';

/// Exercises RootShell's tab-switch + push/pop back-button contract using
/// simple fake tab content, independent of whatever real screens the app
/// wires in - so those screens can change freely without touching this file.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget harness() {
    return MaterialApp(
      home: RootShell(
        tabBuilder: (context, tab) => switch (tab) {
          AppTab.convert => _FakeTabScreen(
            label: 'Convert tab',
            onPushDetail: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const _FakeDetailScreen()),
            ),
          ),
          AppTab.saved => const _FakeTabScreen(label: 'Saved tab'),
          AppTab.settings => const _FakeTabScreen(label: 'Settings tab'),
        },
      ),
    );
  }

  List<String> mockSystemChannelCalls() {
    final calls = <String>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          calls.add(call.method);
          return null;
        });
    return calls;
  }

  Future<void> pressSystemBack(WidgetTester tester) async {
    final ByteData message = const JSONMethodCodec().encodeMethodCall(
      const MethodCall('popRoute'),
    );
    await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage('flutter/navigation', message, (_) {});
    await tester.pumpAndSettle();
  }

  testWidgets('bottom nav switches tabs without exiting', (tester) async {
    final calls = mockSystemChannelCalls();
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Convert tab'), findsOneWidget);

    await tester.tap(find.text('Saved'));
    await tester.pumpAndSettle();
    expect(find.text('Saved tab'), findsOneWidget);
    expect(find.text('Convert tab'), findsNothing);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings tab'), findsOneWidget);

    expect(calls, isNot(contains('SystemNavigator.pop')));
  });

  testWidgets(
    'back on a non-Home tab returns to Home instead of exiting',
    (tester) async {
      final calls = mockSystemChannelCalls();
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saved'));
      await tester.pumpAndSettle();
      expect(find.text('Convert tab'), findsNothing);

      await pressSystemBack(tester);

      expect(find.text('Convert tab'), findsOneWidget);
      expect(calls, isNot(contains('SystemNavigator.pop')));
    },
  );

  testWidgets(
    'pushed detail screen hides the bottom nav and back returns to Home',
    (tester) async {
      final calls = mockSystemChannelCalls();
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Push detail'));
      await tester.pumpAndSettle();

      expect(find.text('Fake detail'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);

      await pressSystemBack(tester);

      expect(find.text('Convert tab'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(calls, isNot(contains('SystemNavigator.pop')));
    },
  );

  testWidgets(
    'in-screen back button on a pushed detail also returns to Home',
    (tester) async {
      await tester.pumpWidget(harness());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Push detail'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Convert tab'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    },
  );

  testWidgets('back on Home with nothing pushed attempts to exit the app', (
    tester,
  ) async {
    final calls = mockSystemChannelCalls();
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    expect(find.text('Convert tab'), findsOneWidget);

    await pressSystemBack(tester);

    expect(calls, contains('SystemNavigator.pop'));
  });

  testWidgets('tabs can be switched again after returning from a detail push', (
    tester,
  ) async {
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Push detail'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Settings tab'), findsOneWidget);
  });
}

class _FakeTabScreen extends StatelessWidget {
  const _FakeTabScreen({required this.label, this.onPushDetail});

  final String label;
  final VoidCallback? onPushDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (onPushDetail != null)
              TextButton(
                onPressed: onPushDetail,
                child: const Text('Push detail'),
              ),
          ],
        ),
      ),
    );
  }
}

class _FakeDetailScreen extends StatelessWidget {
  const _FakeDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(child: Text('Fake detail')),
    );
  }
}
