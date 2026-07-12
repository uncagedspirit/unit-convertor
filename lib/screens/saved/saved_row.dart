import 'package:flutter/material.dart';

import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';

class SavedRow extends StatelessWidget {
  const SavedRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onOpen,
    required this.onRemove,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onOpen;
  final VoidCallback onRemove;

  static const _iconColor = Color(0xFF2C2A2A);
  static const _titleColor = Color(0xFF262223);
  static const _starColor = Color(0xFFE6A23C);

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return Material(
      color: neutrals.subtleFillStrong,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 13, 13),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, size: 23, color: _iconColor),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: fredokaStyle(size: 15.5, color: _titleColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: jakartaStyle(size: 12.5, color: neutrals.textTertiary),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.black.withValues(alpha: 0.035),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: onRemove,
                  child: const SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.star_rounded,
                      size: 20,
                      color: _starColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
