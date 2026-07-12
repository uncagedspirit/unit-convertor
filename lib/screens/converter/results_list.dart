import 'package:flutter/material.dart';

import '../../data/models/unit.dart';
import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';

class ConversionResultsList extends StatelessWidget {
  const ConversionResultsList({
    super.key,
    required this.units,
    required this.formatFor,
    required this.isFavorite,
    required this.onSwap,
    required this.onToggleFavorite,
  });

  final List<ConvertibleUnit> units;
  final String Function(ConvertibleUnit unit) formatFor;
  final bool Function(ConvertibleUnit unit) isFavorite;
  final ValueChanged<ConvertibleUnit> onSwap;
  final ValueChanged<ConvertibleUnit> onToggleFavorite;

  static const _nameColor = Color(0xFF2C2829);
  static const _valueColor = Color(0xFF201D1E);
  static const _starredColor = Color(0xFFE6A23C);
  static const _unstarredColor = Color(0xFFCFC6CB);

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 14),
      itemCount: units.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final u = units[i];
        final starred = isFavorite(u);
        return Container(
          decoration: BoxDecoration(
            color: neutrals.subtleFillStrong,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.fromLTRB(15, 6, 12, 6),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onSwap(u),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                u.name,
                                style: fredokaStyle(
                                  size: 15,
                                  weight: FontWeight.w500,
                                  color: _nameColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 1),
                              Text(
                                u.symbol,
                                style: jakartaStyle(
                                  size: 11.5,
                                  color: neutrals.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              formatFor(u),
                              style: fredokaStyle(size: 19, color: _valueColor),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Material(
                color: Colors.black.withValues(alpha: 0.035),
                borderRadius: BorderRadius.circular(11),
                child: InkWell(
                  borderRadius: BorderRadius.circular(11),
                  onTap: () => onToggleFavorite(u),
                  child: SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      starred ? Icons.star_rounded : Icons.star_border_rounded,
                      size: 20,
                      color: starred ? _starredColor : _unstarredColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
