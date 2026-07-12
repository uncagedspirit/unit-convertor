import 'models/category.dart';
import 'models/unit.dart';

/// Pure conversion math - no state, no Flutter dependency.
class ConversionEngine {
  const ConversionEngine._();

  static double convert(
    Category category,
    ConvertibleUnit from,
    ConvertibleUnit to,
    double value,
  ) {
    if (from is AffineUnit && to is AffineUnit) {
      return to.fromBase(from.toBase(value));
    }
    final fromFactor = (from as LinearUnit).factor;
    final toFactor = (to as LinearUnit).factor;
    return (value * fromFactor) / toFactor;
  }

  /// The unit a category opens with by default: the base unit (factor == 1)
  /// if one exists, otherwise the first unit in the list. Temperature has no
  /// `factor` field on any unit, so this always falls through to Celsius,
  /// matching the original design exactly.
  static ConvertibleUnit defaultUnit(Category category) {
    for (final unit in category.units) {
      if (unit is LinearUnit && unit.factor == 1) return unit;
    }
    return category.units.first;
  }
}
