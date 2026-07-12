import 'package:flutter/material.dart';

import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 10),
      child: Text(text, style: sectionLabelStyle(context.neutrals.textTertiary)),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.neutrals.subtleFillStrong,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: child,
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    final content = Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: fredokaStyle(
                    size: 15.5,
                    weight: FontWeight.w600,
                    color: neutrals.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: jakartaStyle(size: 12.5, color: neutrals.textTertiary),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          Flexible(child: trailing),
        ],
      ),
    );
    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}

class SettingsDivider extends StatelessWidget {
  const SettingsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: context.neutrals.divider);
  }
}

/// A row of mutually-exclusive pill options (used for precision, card
/// style, and theme mode).
class SegmentedChoice<T> extends StatelessWidget {
  const SegmentedChoice({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<(String label, T value)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return Container(
      decoration: BoxDecoration(
        color: neutrals.subtleFill,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: options.map((opt) {
          final selected = opt.$2 == value;
          return Expanded(
            child: Material(
              color: selected ? neutrals.scaffold : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              elevation: selected ? 1 : 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onChanged(opt.$2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    opt.$1,
                    textAlign: TextAlign.center,
                    style: fredokaStyle(
                      size: 15,
                      color: selected ? neutrals.textPrimary : neutrals.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
