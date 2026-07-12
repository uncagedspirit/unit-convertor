import 'package:flutter/material.dart';

import '../theme/app_neutral_colors.dart';
import '../theme/text_styles.dart';

/// Reusable icon + title (+ optional subtitle) placeholder, used for Home's
/// no-search-results state and Saved's nothing-favorited-yet state.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.title, this.subtitle});

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: neutrals.textTertiary),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: fredokaStyle(
                size: 16,
                weight: FontWeight.w500,
                color: neutrals.textTertiary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 5),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: jakartaStyle(
                  size: 13,
                  color: neutrals.textTertiary,
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
