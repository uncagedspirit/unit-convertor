/// Base type for anything that can appear in a [Category]'s unit list.
///
/// Modeled as a sealed type so the conversion engine can switch on the
/// concrete subtype once instead of branching on a boolean flag everywhere.
sealed class ConvertibleUnit {
  const ConvertibleUnit({
    required this.id,
    required this.name,
    required this.symbol,
  });

  final String id;
  final String name;
  final String symbol;
}

/// A unit convertible via a simple multiplicative factor against the
/// category's base unit (the unit whose factor is exactly 1).
final class LinearUnit extends ConvertibleUnit {
  const LinearUnit({
    required super.id,
    required super.name,
    required super.symbol,
    required this.factor,
  });

  final double factor;
}

/// A unit that requires an affine (offset) conversion rather than a plain
/// factor - used for Temperature (Celsius/Fahrenheit/Kelvin).
final class AffineUnit extends ConvertibleUnit {
  const AffineUnit({
    required super.id,
    required super.name,
    required super.symbol,
    required this.toBase,
    required this.fromBase,
  });

  final double Function(double value) toBase;
  final double Function(double value) fromBase;
}
