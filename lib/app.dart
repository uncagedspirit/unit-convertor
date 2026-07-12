import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/models/category.dart';
import 'navigation/root_shell.dart';
import 'navigation/tab_item.dart';
import 'screens/converter/converter_screen.dart';
import 'screens/help/how_to_use_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/legal/privacy_policy_screen.dart';
import 'screens/legal/terms_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/saved/saved_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'state/app_state.dart';
import 'theme/accent_colors.dart';
import 'theme/app_theme.dart';

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final seed = accentColors[appState.accentIndex].seed;
    return MaterialApp(
      title: 'Unit Converter & Calculator Toolkit',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(seed: seed, brightness: Brightness.light),
      darkTheme: buildAppTheme(seed: seed, brightness: Brightness.dark),
      themeMode: appState.themeMode,
      home: const _AppRoot(),
    );
  }
}

/// Decides between Onboarding and the real app shell by returning a
/// different widget from build() - not by pushing/popping a route - so an
/// AppState change (finishing onboarding) always takes effect immediately,
/// with no risk of onboarding lingering in any back-stack afterward.
class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    if (!appState.hasSeenOnboarding) {
      return OnboardingScreen(
        onFinish: () => appState.setHasSeenOnboarding(true),
      );
    }
    return RootShell(
      tabBuilder: (context, tab) => switch (tab) {
        AppTab.convert => HomeScreen(
          onOpenCategory: (category) => _openConverter(context, category),
        ),
        AppTab.saved => SavedScreen(
          onOpen: (category, fromUnitId) =>
              _openConverter(context, category, fromUnitId: fromUnitId),
        ),
        AppTab.settings => SettingsScreen(
          onOpenHowToUse: () => Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: 'how_to_use'),
              builder: (_) => const HowToUseScreen(),
            ),
          ),
          onOpenPrivacyPolicy: () => Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: 'privacy_policy'),
              builder: (_) => const PrivacyPolicyScreen(),
            ),
          ),
          onOpenTerms: () => Navigator.of(context).push(
            MaterialPageRoute(
              settings: const RouteSettings(name: 'terms_of_use'),
              builder: (_) => const TermsScreen(),
            ),
          ),
        ),
      },
    );
  }

  void _openConverter(
    BuildContext context,
    Category category, {
    String? fromUnitId,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'converter'),
        builder: (_) => ConverterScreen(
          categoryId: category.id,
          initialFromUnitId: fromUnitId,
        ),
      ),
    );
  }
}
