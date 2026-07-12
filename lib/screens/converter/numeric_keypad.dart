import 'package:flutter/material.dart';

import '../../theme/text_styles.dart';

class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onDot,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onDot;
  final VoidCallback onBackspace;

  static const _keys = [
    '7', '8', '9', //
    '4', '5', '6', //
    '1', '2', '3', //
    '.', '0', 'del', //
  ];

  static const _delColor = Color(0xFFEBE4E9);
  static const _keyColor = Color(0xFFF4EEF2);
  static const _labelColor = Color(0xFF2A2627);
  static const _iconColor = Color(0xFF3A3537);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 9,
      crossAxisSpacing: 9,
      childAspectRatio: 2.1,
      children: _keys.map((k) {
        final isDel = k == 'del';
        final isDot = k == '.';
        return Material(
          color: isDel ? _delColor : _keyColor,
          borderRadius: BorderRadius.circular(17),
          child: InkWell(
            borderRadius: BorderRadius.circular(17),
            onTap: () {
              if (isDel) {
                onBackspace();
              } else if (isDot) {
                onDot();
              } else {
                onDigit(k);
              }
            },
            child: Center(
              child: isDel
                  ? const Icon(
                      Icons.backspace_rounded,
                      size: 25,
                      color: _iconColor,
                    )
                  : Text(k, style: fredokaStyle(size: 24, color: _labelColor)),
            ),
          ),
        );
      }).toList(),
    );
  }
}
