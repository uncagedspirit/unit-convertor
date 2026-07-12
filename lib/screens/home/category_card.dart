import 'package:flutter/material.dart';

import '../../data/models/category.dart';
import '../../theme/text_styles.dart';

/// A single category tile on the Home grid - fixed dark-on-pastel text/icon
/// regardless of the app's light/dark theme mode, matching the design
/// (the card's own light background always needs dark text for contrast).
class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
    required this.color,
    required this.cornerRadius,
    required this.onTap,
  });

  final Category category;
  final Color color;
  final double cornerRadius;
  final VoidCallback onTap;

  static const _iconColor = Color(0xFF2C2A2A);
  static const _nameColor = Color(0xFF262223);
  static const _exampleColor = Color(0x85282426); // rgba(40,36,38,0.52)

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(cornerRadius);
    return Material(
      color: color,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(category.icon, size: 25, color: _iconColor),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: fredokaStyle(size: 18, color: _nameColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    category.example,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: jakartaStyle(size: 12, color: _exampleColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
