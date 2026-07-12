import 'package:flutter_test/flutter_test.dart';
import 'package:unit_converter/data/keypad_input.dart';

void main() {
  group('KeypadInput.pressDigit', () {
    test('replaces a lone leading zero instead of appending', () {
      expect(KeypadInput.pressDigit('0', '5'), '5');
    });

    test('appends to any other value', () {
      expect(KeypadInput.pressDigit('12', '3'), '123');
    });

    test('caps input at 14 characters', () {
      const fourteen = '12345678901234';
      expect(fourteen.length, KeypadInput.maxLength);
      expect(KeypadInput.pressDigit(fourteen, '9'), fourteen);
    });
  });

  group('KeypadInput.pressDot', () {
    test('adds a decimal point', () {
      expect(KeypadInput.pressDot('12'), '12.');
    });

    test('is a no-op if a decimal point already exists', () {
      expect(KeypadInput.pressDot('12.5'), '12.5');
    });

    test('starting from empty produces "0."', () {
      expect(KeypadInput.pressDot(''), '0.');
    });
  });

  group('KeypadInput.pressBackspace', () {
    test('removes the last character', () {
      expect(KeypadInput.pressBackspace('123'), '12');
    });

    test('is a safe no-op on an empty string', () {
      expect(KeypadInput.pressBackspace(''), '');
    });

    test('single character becomes empty', () {
      expect(KeypadInput.pressBackspace('1'), '');
    });
  });
}
