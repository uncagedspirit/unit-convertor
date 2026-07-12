import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/category_data.dart';
import '../../data/conversion_engine.dart';
import '../../data/models/category.dart';
import '../../data/models/unit.dart';
import '../../data/number_format.dart';
import '../../state/app_state.dart';
import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/empty_state.dart';
import 'saved_row.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key, required this.onOpen});

  /// Called with the category and from-unit id to reopen in the Converter.
  final void Function(Category category, String fromUnitId) onOpen;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    final appState = context.watch<AppState>();
    final entries = _buildEntries(appState);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Saved',
                    style: fredokaStyle(
                      size: 30,
                      letterSpacing: -0.5,
                      color: neutrals.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Your starred conversions',
                    style: jakartaStyle(size: 13.5, color: neutrals.textTertiary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: entries.isEmpty
                  ? const EmptyState(
                      icon: Icons.star_rounded,
                      title: 'Nothing saved yet',
                      subtitle:
                          'Tap the star next to any\nconversion to keep it here.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final e = entries[i];
                        final result = ConversionEngine.convert(
                          e.category,
                          e.fromUnit,
                          e.toUnit,
                          1,
                        );
                        final formatted = NumberFormat.format(
                          result,
                          significantDigits: appState.precision,
                          grouped: appState.grouping,
                        );
                        return SavedRow(
                          title:
                              '${e.category.name} · ${e.fromUnit.symbol} → ${e.toUnit.symbol}',
                          subtitle:
                              '1 ${e.fromUnit.symbol}  =  $formatted ${e.toUnit.symbol}',
                          icon: e.category.icon,
                          color: e.category.colorFor(appState.paletteStyle),
                          onOpen: () => onOpen(e.category, e.fromUnit.id),
                          onRemove: () => appState.toggleFavorite(e.key),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<_SavedEntry> _buildEntries(AppState appState) {
    final entries = <_SavedEntry>[];
    for (final key in appState.favorites) {
      final parts = key.split('|');
      if (parts.length != 3) continue;
      final category = findCategory(parts[0]);
      if (category == null) continue;
      final fromUnit = _findUnit(category, parts[1]);
      final toUnit = _findUnit(category, parts[2]);
      if (fromUnit == null || toUnit == null) continue;
      entries.add(
        _SavedEntry(
          key: key,
          category: category,
          fromUnit: fromUnit,
          toUnit: toUnit,
        ),
      );
    }
    return entries;
  }

  ConvertibleUnit? _findUnit(Category category, String id) {
    for (final u in category.units) {
      if (u.id == id) return u;
    }
    return null;
  }
}

class _SavedEntry {
  const _SavedEntry({
    required this.key,
    required this.category,
    required this.fromUnit,
    required this.toUnit,
  });

  final String key;
  final Category category;
  final ConvertibleUnit fromUnit;
  final ConvertibleUnit toUnit;
}
