/// The keypad's string-state-machine, ported from the design's `press()`.
/// Operates on the raw input string, not a parsed number, so partial states
/// like "3." or "" are representable while typing.
class KeypadInput {
  const KeypadInput._();

  static const maxLength = 14;

  static String pressDigit(String current, String digit) {
    if (current == '0') return digit;
    if (current.length < maxLength) return current + digit;
    return current;
  }

  static String pressDot(String current) {
    if (current.contains('.')) return current;
    return '${current.isEmpty ? '0' : current}.';
  }

  static String pressBackspace(String current) {
    if (current.isEmpty) return current;
    return current.substring(0, current.length - 1);
  }
}
