import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/services/analytics_service.dart';

void main() {
  // AnalyticsService.init() is never called in tests (it would try to talk
  // to the real Firebase platform channel), so every method must be a safe
  // no-op in that state - this is the same state real widget tests run in.
  group('AnalyticsService before init()', () {
    test('observer is null', () {
      expect(AnalyticsService.observer, isNull);
    });

    test('logScreenView does not throw', () async {
      await expectLater(
        AnalyticsService.logScreenView('some_screen'),
        completes,
      );
    });
  });
}
