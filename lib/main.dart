import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/analytics_service.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.loadFromPrefs();
  await AnalyticsService.init();
  runApp(
    ChangeNotifierProvider.value(value: appState, child: const UnitConverterApp()),
  );
}
