import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/category_data.dart';
import '../../data/models/category.dart';
import '../../state/app_state.dart';
import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';
import 'accent_color_picker.dart';
import 'settings_section.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.onOpenHowToUse,
    required this.onOpenPrivacyPolicy,
    required this.onOpenTerms,
  });

  final VoidCallback onOpenHowToUse;
  final VoidCallback onOpenPrivacyPolicy;
  final VoidCallback onOpenTerms;

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    final appState = context.watch<AppState>();
    final totalUnits = categories.fold<int>(0, (sum, c) => sum + c.units.length);

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
                    'Settings',
                    style: fredokaStyle(
                      size: 30,
                      letterSpacing: -0.5,
                      color: neutrals.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tune how results are shown',
                    style: jakartaStyle(size: 13.5, color: neutrals.textTertiary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 6, 22, 32),
                children: [
                  const SettingsSectionLabel('ACCENT COLOR'),
                  AccentColorPicker(
                    selectedIndex: appState.accentIndex,
                    onSelect: appState.setAccentIndex,
                  ),

                  const SettingsSectionLabel('THEME'),
                  SegmentedChoice<ThemeMode>(
                    options: const [
                      ('System', ThemeMode.system),
                      ('Light', ThemeMode.light),
                      ('Dark', ThemeMode.dark),
                    ],
                    value: appState.themeMode,
                    onChanged: appState.setThemeMode,
                  ),

                  const SettingsSectionLabel('CATEGORY CARD STYLE'),
                  SegmentedChoice<PaletteStyle>(
                    options: const [
                      ('Muted', PaletteStyle.muted),
                      ('Vivid', PaletteStyle.vivid),
                    ],
                    value: appState.paletteStyle,
                    onChanged: appState.setPaletteStyle,
                  ),

                  const SettingsSectionLabel('SIGNIFICANT FIGURES'),
                  SegmentedChoice<int>(
                    options: const [('4', 4), ('6', 6), ('8', 8)],
                    value: appState.precision,
                    onChanged: appState.setPrecision,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 10, 4, 0),
                    child: Text(
                      'Higher precision shows more decimal places in every result.',
                      style: jakartaStyle(size: 12.5, color: neutrals.textTertiary, height: 1.5),
                    ),
                  ),

                  const SettingsSectionLabel('CARD ROUNDNESS'),
                  SettingsCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Slider(
                      value: appState.cornerRadius,
                      min: 12,
                      max: 32,
                      divisions: 10,
                      label: appState.cornerRadius.round().toString(),
                      onChanged: appState.setCornerRadius,
                    ),
                  ),

                  const SettingsSectionLabel('BEHAVIOR'),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsRow(
                          title: 'Group thousands',
                          subtitle: 'Show separators like 1,000',
                          trailing: Switch(
                            value: appState.grouping,
                            onChanged: appState.setGrouping,
                          ),
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Show recents on Home',
                          subtitle: 'Quick-access chips for recently opened categories',
                          trailing: Switch(
                            value: appState.showRecents,
                            onChanged: appState.setShowRecents,
                          ),
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Haptic feedback',
                          subtitle: 'Vibrate slightly on keypad taps',
                          trailing: Switch(
                            value: appState.hapticsEnabled,
                            onChanged: appState.setHapticsEnabled,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SettingsSectionLabel('YOUR DATA'),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsRow(
                          title: 'Clear recents',
                          subtitle: 'Remove all recently opened categories',
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: neutrals.textTertiary,
                          ),
                          onTap: () async {
                            final ok = await _confirm(
                              context,
                              title: 'Clear recents?',
                              message: 'This removes your recently opened categories from Home. Your saved conversions are not affected.',
                              confirmLabel: 'Clear',
                            );
                            if (ok) appState.clearRecents();
                          },
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Clear saved conversions',
                          subtitle: 'Remove everything from the Saved tab',
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: neutrals.textTertiary,
                          ),
                          onTap: () async {
                            final ok = await _confirm(
                              context,
                              title: 'Clear saved conversions?',
                              message: 'This removes every starred conversion. This can\'t be undone.',
                              confirmLabel: 'Clear',
                            );
                            if (ok) appState.clearFavorites();
                          },
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Reset settings',
                          subtitle: 'Restore all options above to their defaults',
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: neutrals.textTertiary,
                          ),
                          onTap: () async {
                            final ok = await _confirm(
                              context,
                              title: 'Reset settings?',
                              message: 'This restores theme, precision, and display options to their defaults. Recents and saved conversions are not affected.',
                              confirmLabel: 'Reset',
                            );
                            if (ok) appState.resetSettings();
                          },
                        ),
                      ],
                    ),
                  ),

                  const SettingsSectionLabel('HELP'),
                  SettingsCard(
                    child: SettingsRow(
                      title: 'How to use this app',
                      trailing: Icon(
                        Icons.chevron_right_rounded,
                        color: neutrals.textTertiary,
                      ),
                      onTap: onOpenHowToUse,
                    ),
                  ),

                  const SettingsSectionLabel('ABOUT'),
                  SettingsCard(
                    child: Column(
                      children: [
                        SettingsRow(
                          title: 'Privacy Policy',
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: neutrals.textTertiary,
                          ),
                          onTap: onOpenPrivacyPolicy,
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Terms of Use',
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: neutrals.textTertiary,
                          ),
                          onTap: onOpenTerms,
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Version',
                          trailing: Text(
                            '1.0.0',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: jakartaStyle(
                              size: 14.5,
                              weight: FontWeight.w600,
                              color: neutrals.textTertiary,
                            ),
                          ),
                        ),
                        const SettingsDivider(),
                        SettingsRow(
                          title: 'Library',
                          trailing: Text(
                            '${categories.length} categories · $totalUnits units',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: jakartaStyle(
                              size: 14.5,
                              weight: FontWeight.w600,
                              color: neutrals.textTertiary,
                            ),
                          ),
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
