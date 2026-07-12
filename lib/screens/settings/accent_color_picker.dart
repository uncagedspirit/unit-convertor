import 'package:flutter/material.dart';

import '../../theme/accent_colors.dart';

class AccentColorPicker extends StatelessWidget {
  const AccentColorPicker({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: List.generate(accentColors.length, (i) {
        final selected = i == selectedIndex;
        final entry = accentColors[i];
        return GestureDetector(
          onTap: () => onSelect(i),
          child: Semantics(
            label: entry.name,
            selected: selected,
            button: true,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: entry.seed, shape: BoxShape.circle),
              child: selected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
