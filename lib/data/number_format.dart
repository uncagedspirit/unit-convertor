import 'dart:math' as math;

/// Result display formatting, ported from the design's `fmt()`/`clean()`.
class NumberFormat {
  const NumberFormat._();

  /// Formats [n] to [significantDigits] significant figures, with optional
  /// thousands grouping, falling back to scientific notation for extremely
  /// large or small magnitudes.
  static String format(
    double n, {
    required int significantDigits,
    required bool grouped,
  }) {
    if (n == 0) return '0';
    if (!n.isFinite) return '—';
    final abs = n.abs();
    if (abs >= 1e15 || abs < 1e-9) {
      final expDigits = (significantDigits - 1).clamp(1, 20);
      return n.toStringAsExponential(expDigits);
    }
    final d = (math.log(abs) / math.ln10).ceil();
    final power = significantDigits - d;
    final factor = math.pow(10, power).toDouble();
    final rounded = (n * factor).round() / factor;
    final dec = power.clamp(0, 12);
    return _toDisplayString(rounded, maxFractionDigits: dec, grouped: grouped);
  }

  /// Re-stringifies a converted value (rounded to 12 significant figures) so
  /// it can become the new keypad input after a tap-to-swap.
  static String clean(double n) {
    if (!n.isFinite || n == 0) return '0';
    final precise = double.parse(n.toStringAsPrecision(12));
    var s = precise.toString();
    if (s.endsWith('.0')) s = s.substring(0, s.length - 2);
    return s;
  }

  static String _toDisplayString(
    double value, {
    required int maxFractionDigits,
    required bool grouped,
  }) {
    final isNegative = value < 0;
    final fixed = value.abs().toStringAsFixed(maxFractionDigits);
    final parts = fixed.split('.');
    var intPart = parts[0];
    var fracPart = parts.length > 1 ? parts[1] : '';
    fracPart = fracPart.replaceFirst(RegExp(r'0+$'), '');
    if (grouped) intPart = _groupThousands(intPart);
    final sign = isNegative ? '-' : '';
    return fracPart.isEmpty ? '$sign$intPart' : '$sign$intPart.$fracPart';
  }

  static String _groupThousands(String digits) {
    final buffer = StringBuffer();
    final len = digits.length;
    for (var i = 0; i < len; i++) {
      if (i > 0 && (len - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
