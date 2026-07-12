import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/data/number_format.dart';

void main() {
  group('NumberFormat.format', () {
    test('zero', () {
      expect(NumberFormat.format(0, significantDigits: 6, grouped: true), '0');
    });

    test('non-finite values render as an em dash', () {
      expect(
        NumberFormat.format(double.nan, significantDigits: 6, grouped: true),
        '—',
      );
      expect(
        NumberFormat.format(
          double.infinity,
          significantDigits: 6,
          grouped: true,
        ),
        '—',
      );
    });

    test('rounds to the requested significant figures, with grouping', () {
      expect(
        NumberFormat.format(1234.5678, significantDigits: 6, grouped: true),
        '1,234.57',
      );
    });

    test('grouping can be disabled', () {
      expect(
        NumberFormat.format(1234.5678, significantDigits: 6, grouped: false),
        '1234.57',
      );
    });

    test('exact power of ten at default precision', () {
      expect(
        NumberFormat.format(1000, significantDigits: 6, grouped: true),
        '1,000',
      );
    });

    test('trims trailing zero decimals', () {
      expect(
        NumberFormat.format(2.5, significantDigits: 4, grouped: true),
        '2.5',
      );
    });

    test('lower significant digits round more aggressively', () {
      expect(
        NumberFormat.format(3.14159265, significantDigits: 4, grouped: true),
        '3.142',
      );
      expect(
        NumberFormat.format(3.14159265, significantDigits: 8, grouped: true),
        '3.1415927',
      );
    });

    test('very large numbers fall back to scientific notation', () {
      final result = NumberFormat.format(
        1.23e16,
        significantDigits: 6,
        grouped: true,
      );
      expect(result, contains('e+16'));
    });

    test('very small numbers fall back to scientific notation', () {
      final result = NumberFormat.format(
        1e-10,
        significantDigits: 6,
        grouped: true,
      );
      expect(result, contains('e-10'));
    });

    test('negative values keep their sign', () {
      expect(
        NumberFormat.format(-40, significantDigits: 6, grouped: true),
        '-40',
      );
    });
  });

  group('NumberFormat.clean', () {
    test('whole numbers have no trailing .0', () {
      expect(NumberFormat.clean(5), '5');
    });

    test('preserves meaningful decimals', () {
      expect(NumberFormat.clean(1609.344), '1609.344');
    });

    test('non-finite falls back to 0', () {
      expect(NumberFormat.clean(double.nan), '0');
      expect(NumberFormat.clean(double.infinity), '0');
    });

    test('zero', () {
      expect(NumberFormat.clean(0), '0');
    });
  });
}
