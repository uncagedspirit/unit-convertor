# Unit Converter & Calculator Toolkit

A fast unit converter for Android (and desktop/web via Flutter), covering
10 categories and 70 units: Length, Weight, Temperature, Volume, Area,
Speed, Time, Data, Energy, and Pressure.

- **No accounts, no ads.** Settings, favorites, and recent categories are
  stored only on-device via `shared_preferences`. The app uses Firebase
  Analytics (Android only, no Crashlytics) for anonymous usage insights -
  see `lib/screens/legal/privacy_policy_screen.dart` and
  `lib/services/analytics_service.dart`.
- Live conversion with a custom keypad, tap-to-swap results, and starred
  favorites.
- Deeply customizable: accent color (8 choices, pink default), light/dark/
  system theme, category card style, card corner roundness, significant
  figures, thousands grouping, haptics, and show/hide recents - all in
  Settings.
- First-run onboarding and a persistent "How to use this app" screen
  instead of any pre-populated/dummy data.

## Before you publish

A few things still need attention before your first Play Store upload:

1. **Support contact email** - `your-support-email@example.com` appears in
   `lib/screens/legal/privacy_policy_screen.dart`, `lib/screens/legal/
   terms_screen.dart`, `docs/privacy-policy.html`, and `docs/terms.html`.
   Replace all four with a real address you monitor.
2. **Back up the release keystore** - `android/app/upload-keystore.jks` and
   `android/key.properties` are gitignored on purpose (never commit
   signing secrets) but that also means **they exist only on this
   machine**. Copy both somewhere safe now (a password manager or
   encrypted backup) - if you lose them, you can never publish an update
   to this app under the same Play Store listing again. Google's Play App
   Signing can help recover from a lost *upload* key, but there's no
   recovery path if you've never enrolled in that first.
3. **Play Console Data Safety form** - since this app now uses Firebase
   Analytics, declare "Analytics" data collection (usage/app interactions,
   device/app info) with "anonymous, not linked to identity" - see
   [Firebase's own guide](https://firebase.google.com/docs/android/play-data-disclosure)
   for exactly what to check. The advertising ID is explicitly *not*
   collected (see `AndroidManifest.xml`), so it shouldn't be declared.
3. **Play Console Data Safety form** - since this app now uses Firebase
   Analytics, declare "Analytics" data collection (usage/app interactions,
   device/app info) with "anonymous, not linked to identity" - see
   [Firebase's own guide](https://firebase.google.com/docs/android/play-data-disclosure)
   for exactly what to check. The advertising ID is explicitly *not*
   collected (see `AndroidManifest.xml`), so it shouldn't be declared.

## Legal pages (Privacy Policy / Terms of Use)

`docs/` contains static, dependency-free HTML versions of the in-app
Privacy Policy and Terms of Use, content-matched to the in-app copy. Google
Play requires a privacy policy at a public URL, not just in-app text -
enable **GitHub Pages** for this repo (Settings → Pages → deploy from the
`main` branch, `/docs` folder) to get a public link to paste into Play
Console, e.g. `https://<username>.github.io/<repo>/privacy-policy.html`.

## Development

```
flutter pub get
flutter analyze
flutter test
flutter build apk --debug              # sideload-able APK for manual testing
flutter build apk --release --target-platform android-arm64 --analyze-size
flutter build appbundle --release      # build/app/outputs/bundle/release/app-release.aab, for Play Store upload
```

The App Bundle is signed automatically using `android/key.properties` +
`android/app/upload-keystore.jks` if present (see "Before you publish"
above); it falls back to debug signing - **not upload-ready** - if that
keystore is missing, e.g. on a fresh checkout of this repo on another
machine.

No emulator is required for any of the above - the test suite drives every
screen (including back-button/navigation behavior) headlessly via
`flutter_test`.

### Structure

- `lib/data/` - category/unit tables and pure conversion/formatting logic,
  ported from the original design spec.
- `lib/state/app_state.dart` - the single `ChangeNotifier` for settings,
  favorites, and recents, persisted via `shared_preferences`.
- `lib/navigation/root_shell.dart` - the 3-tab bottom nav + back-button
  hierarchy (Home is the only screen where back exits the app).
- `lib/screens/` - Home, Converter, Saved, Settings, onboarding, help, and
  legal screens.
- `lib/theme/` - accent-color seeding, category card palette, and fonts
  (self-hosted Fredoka + Plus Jakarta Sans variable fonts, not the
  `google_fonts` package, to avoid its runtime fetch/size overhead).
- `lib/services/analytics_service.dart` - the Firebase Analytics wrapper
  (Android only; every method safely no-ops if Firebase was never
  initialized, which is the state all widget tests run in).
- `lib/services/analytics_service.dart` - the Firebase Analytics wrapper
  (Android only; every method safely no-ops if Firebase was never
  initialized, which is the state all widget tests run in).
