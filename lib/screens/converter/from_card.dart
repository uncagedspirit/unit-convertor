import 'package:flutter/material.dart';

import '../../data/models/unit.dart';
import '../../theme/text_styles.dart';

class FromCard extends StatelessWidget {
  const FromCard({
    super.key,
    required this.color,
    required this.unit,
    required this.valueDisplay,
    required this.onClear,
    required this.cornerRadius,
  });

  final Color color;
  final ConvertibleUnit unit;
  final String valueDisplay;
  final VoidCallback onClear;
  final double cornerRadius;

  static const _labelColor = Color(0x80282426); // rgba(40,36,38,0.5)
  static const _chipNameColor = Color(0xFF262223);
  static const _chipSymbolColor = Color(0x80282426);
  static const _closeIconColor = Color(0xFF3A3537);
  static const _valueColor = Color(0xFF201D1E);
  static const _valueSymbolColor = Color(0x73201D1E); // rgba(32,29,30,0.45)

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FROM',
                style: jakartaStyle(
                  size: 11,
                  weight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: _labelColor,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.62),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          unit.name,
                          style: fredokaStyle(size: 14, color: _chipNameColor),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          unit.symbol,
                          style: jakartaStyle(
                            size: 12,
                            weight: FontWeight.w600,
                            color: _chipSymbolColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onClear,
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: _closeIconColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  valueDisplay,
                  style: fredokaStyle(size: 46, color: _valueColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 9),
              Text(
                unit.symbol,
                style: fredokaStyle(
                  size: 20,
                  weight: FontWeight.w500,
                  color: _valueSymbolColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
