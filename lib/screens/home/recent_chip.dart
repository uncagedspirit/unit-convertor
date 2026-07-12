import 'package:flutter/material.dart';

import '../../data/models/category.dart';
import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';

class RecentChip extends StatelessWidget {
  const RecentChip({
    super.key,
    required this.category,
    required this.color,
    required this.onTap,
  });

  final Category category;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return Material(
      color: neutrals.subtleFill,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                category.name,
                style: jakartaStyle(
                  size: 13.5,
                  weight: FontWeight.w600,
                  color: neutrals.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
