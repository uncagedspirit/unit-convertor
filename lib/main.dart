import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/analytics_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Portrait-only: every screen (keypad, converter, onboarding) is laid out
  // for a tall aspect ratio, so allowing landscape would crop those fixed
  // layouts. A unit converter has no landscape use case.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final appState = AppState();
  try {
    await appState.loadFromPrefs();
  } catch (_) {
    // Corrupted/unavailable SharedPreferences: continue with in-memory
    // defaults rather than blocking startup entirely.
  }
  await AnalyticsService.init();
  runApp(
    ChangeNotifierProvider.value(
      value: appState,
      child: const UnitConverterApp(),
    ),
  );
}
