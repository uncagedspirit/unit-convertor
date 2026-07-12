import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/data/category_data.dart';
import 'package:unit_converter/data/conversion_engine.dart';
import 'package:unit_converter/data/models/unit.dart';

void main() {
  group('ConversionEngine.convert - linear categories', () {
    test('1 mile equals 1609.344 meters', () {
      final length = findCategory('length')!;
      final mile = length.units.firstWhere((u) => u.id == 'mi');
      final meter = length.units.firstWhere((u) => u.id == 'm');
      expect(ConversionEngine.convert(length, mile, meter, 1), 1609.344);
    });

    test('1 GB equals 1e9 bytes', () {
      final data = findCategory('data')!;
      final gb = data.units.firstWhere((u) => u.id == 'GB');
      final byte = data.units.firstWhere((u) => u.id == 'B');
      expect(ConversionEngine.convert(data, gb, byte, 1), 1e9);
    });

    test('round trip: km -> mi -> km returns to original value', () {
      final length = findCategory('length')!;
      final km = length.units.firstWhere((u) => u.id == 'km');
      final mi = length.units.firstWhere((u) => u.id == 'mi');
      final toMiles = ConversionEngine.convert(length, km, mi, 5);
      final backToKm = ConversionEngine.convert(length, mi, km, toMiles);
      expect(backToKm, closeTo(5, 1e-9));
    });
  });

  group('ConversionEngine.convert - temperature (affine)', () {
    final temp = findCategory('temp')!;
    final celsius = temp.units.firstWhere((u) => u.id == 'c');
    final fahrenheit = temp.units.firstWhere((u) => u.id == 'f');
    final kelvin = temp.units.firstWhere((u) => u.id == 'k');

    test('0C equals 32F', () {
      expect(ConversionEngine.convert(temp, celsius, fahrenheit, 0), 32);
    });

    test('0C equals 273.15K', () {
      expect(
        ConversionEngine.convert(temp, celsius, kelvin, 0),
        closeTo(273.15, 1e-9),
      );
    });

    test('32F equals 0C', () {
      expect(
        ConversionEngine.convert(temp, fahrenheit, celsius, 32),
        closeTo(0, 1e-9),
      );
    });

    test('100C equals 212F', () {
      expect(ConversionEngine.convert(temp, celsius, fahrenheit, 100), 212);
    });
  });

  group('ConversionEngine.defaultUnit', () {
    test('picks the factor==1 base unit for linear categories', () {
      final length = findCategory('length')!;
      final def = ConversionEngine.defaultUnit(length);
      expect(def.id, 'm');

      final mass = findCategory('mass')!;
      expect(ConversionEngine.defaultUnit(mass).id, 'kg');
    });

    test('falls back to the first unit for Temperature (Celsius)', () {
      final temp = findCategory('temp')!;
      final def = ConversionEngine.defaultUnit(temp);
      expect(def.id, 'c');
      expect(def, isA<AffineUnit>());
    });
  });

  group('Category.matches search', () {
    test('matches by category name', () {
      expect(findCategory('length')!.matches('leng'), isTrue);
    });

    test('matches by unit name substring', () {
      expect(findCategory('temp')!.matches('fahrenheit'), isTrue);
    });

    test('matches by unit symbol substring', () {
      expect(findCategory('pressure')!.matches('psi'), isTrue);
    });

    test('does not match unrelated query', () {
      expect(findCategory('length')!.matches('xyz123'), isFalse);
    });

    test('empty query matches everything', () {
      expect(findCategory('length')!.matches(''), isTrue);
    });
  });

  test('all 10 categories and ~70 units are present', () {
    expect(categories.length, 10);
    final totalUnits = categories.fold<int>(0, (sum, c) => sum + c.units.length);
    expect(totalUnits, 70);
  });
}
