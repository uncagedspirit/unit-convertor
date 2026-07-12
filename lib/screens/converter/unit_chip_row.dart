import 'package:flutter/material.dart';

import '../../data/models/unit.dart';
import '../../theme/text_styles.dart';

class UnitChipRow extends StatelessWidget {
  const UnitChipRow({
    super.key,
    required this.units,
    required this.selectedId,
    required this.onSelect,
  });

  final List<ConvertibleUnit> units;
  final String selectedId;
  final ValueChanged<ConvertibleUnit> onSelect;

  static const _selectedBg = Color(0xFF221F1F);
  static const _unselectedBg = Color(0xFFF2ECF0);
  static const _unselectedText = Color(0xFF5A5358);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        itemCount: units.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final u = units[i];
          final selected = u.id == selectedId;
          return Material(
            color: selected ? _selectedBg : _unselectedBg,
            borderRadius: BorderRadius.circular(13),
            child: InkWell(
              borderRadius: BorderRadius.circular(13),
              onTap: () => onSelect(u),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                child: Text(
                  u.symbol,
                  style: fredokaStyle(
                    size: 14,
                    color: selected ? Colors.white : _unselectedText,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
