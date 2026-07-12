import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/category_data.dart';
import '../../data/models/category.dart';
import '../../state/app_state.dart';
import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';
import '../../widgets/empty_state.dart';
import 'category_card.dart';
import 'recent_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onOpenCategory});

  /// Called (after the tap has already been recorded into recents) with the
  /// category the user chose to open.
  final void Function(Category category) onOpenCategory;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _open(Category category) {
    context.read<AppState>().recordRecent(category.id);
    widget.onOpenCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    final appState = context.watch<AppState>();
    final filtered = categories.where((c) => c.matches(_query)).toList();
    final trimmedQuery = _query.trim();
    final showRecents =
        appState.showRecents &&
        trimmedQuery.isEmpty &&
        appState.recents.isNotEmpty;
    final recentCats = appState.recents
        .map(findCategory)
        .whereType<Category>()
        .toList();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit Converter',
                    style: fredokaStyle(
                      size: 30,
                      letterSpacing: -0.5,
                      color: neutrals.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Convert anything, instantly',
                    style: jakartaStyle(size: 13.5, color: neutrals.textTertiary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: neutrals.subtleFill,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 22,
                          color: neutrals.textTertiary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) => setState(() => _query = v),
                            style: jakartaStyle(
                              size: 15,
                              weight: FontWeight.w500,
                              color: neutrals.textPrimary,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 13),
                              hintText: 'Search units or categories',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(22, 6, 22, 22),
                    sliver: SliverList.list(
                      children: [
                        if (showRecents) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 6, 2, 10),
                            child: Text(
                              'RECENT',
                              style: sectionLabelStyle(neutrals.textTertiary),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: recentCats.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, i) {
                                final cat = recentCats[i];
                                return RecentChip(
                                  category: cat,
                                  color: cat.colorFor(appState.paletteStyle),
                                  onTap: () => _open(cat),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 14),
                        ],
                        if (filtered.isEmpty)
                          const EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No matches found',
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filtered.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  // Reserves enough height for a category
                                  // name that wraps to 2 lines (e.g.
                                  // "Temperature") at phone widths, not
                                  // just the 1-line case.
                                  childAspectRatio: 1.05,
                                ),
                            itemBuilder: (context, i) {
                              final cat = filtered[i];
                              return CategoryCard(
                                category: cat,
                                color: cat.colorFor(appState.paletteStyle),
                                cornerRadius: appState.cornerRadius,
                                onTap: () => _open(cat),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
