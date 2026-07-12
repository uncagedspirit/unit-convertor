import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Thin wrapper around Firebase Analytics, scoped to Android only - there's
/// no Firebase configuration for the Windows/web build targets, and no
/// Crashlytics or any other Firebase product is in use.
///
/// Every method is a safe no-op if [init] was never called (e.g. in widget
/// tests, which never touch Firebase), so screens can call these
/// unconditionally without needing to know whether Analytics is active.
class AnalyticsService {
  const AnalyticsService._();

  static bool get isSupported => defaultTargetPlatform == TargetPlatform.android;

  static FirebaseAnalytics? _instance;

  static Future<void> init() async {
    if (!isSupported) return;
    await Firebase.initializeApp();
    _instance = FirebaseAnalytics.instance;
  }

  /// Attach to a [Navigator] to automatically log a screen view whenever a
  /// route is pushed/popped/replaced.
  static FirebaseAnalyticsObserver? get observer {
    final instance = _instance;
    if (instance == null) return null;
    return FirebaseAnalyticsObserver(analytics: instance);
  }

  /// For screens that aren't routes (e.g. bottom-nav tab switches, which are
  /// a state change rather than a push) - logs a screen view manually.
  static Future<void> logScreenView(String screenName) async {
    final instance = _instance;
    if (instance == null) return;
    await instance.logScreenView(screenName: screenName);
  }
}
