import 'package:flutter/material.dart';

import '../services/analytics_service.dart';
import 'tab_item.dart';

String _tabScreenName(AppTab tab) => switch (tab) {
  AppTab.convert => 'home',
  AppTab.saved => 'saved',
  AppTab.settings => 'settings',
};

/// Owns the 3-tab bottom nav (Convert/Saved/Settings) plus a single shared
/// [Navigator] used for full-screen pushed routes (Converter, legal/help
/// screens). See the back-button contract this enforces:
///
/// - A pushed sub-screen's back pops it, returning to whatever launched it.
/// - A non-Home tab's back switches to the Home (Convert) tab instead of
///   exiting.
/// - Home tab, nothing pushed: back exits the app - the only exit point.
///
/// Tab switches are plain state changes (not Navigator pushes) so switching
/// tabs never grows the back stack; only genuinely new screens do.
class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.tabBuilder});

  /// Builds the root content for a given tab. Injected so real screens can
  /// replace the placeholders without this file needing to change.
  final Widget Function(BuildContext context, AppTab tab) tabBuilder;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  final ValueNotifier<AppTab> _tabNotifier = ValueNotifier(AppTab.convert);

  AppTab get _tab => _tabNotifier.value;
  bool get _canPopNested => _navKey.currentState?.canPop() ?? false;

  @override
  void initState() {
    super.initState();
    AnalyticsService.logScreenView(_tabScreenName(_tab));
  }

  @override
  void dispose() {
    _tabNotifier.dispose();
    super.dispose();
  }

  void _switchTab(AppTab t) {
    if (t == _tab) return;
    setState(() => _tabNotifier.value = t);
    AnalyticsService.logScreenView(_tabScreenName(t));
  }

  void _onNestedNavChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final canPop = !_canPopNested && _tab == AppTab.convert;
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_canPopNested) {
          _navKey.currentState!.pop();
          return;
        }
        if (_tab != AppTab.convert) {
          _switchTab(AppTab.convert);
        }
      },
      child: Scaffold(
        body: Navigator(
          key: _navKey,
          observers: [
            _ShellNavigatorObserver(_onNestedNavChanged),
            ?AnalyticsService.observer,
          ],
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (context) => _TabSwitcher(
              tabNotifier: _tabNotifier,
              tabBuilder: widget.tabBuilder,
            ),
          ),
        ),
        bottomNavigationBar: _canPopNested
            ? null
            : _BottomNav(current: _tab, onSelect: _switchTab),
      ),
    );
  }
}

class _ShellNavigatorObserver extends NavigatorObserver {
  _ShellNavigatorObserver(this.onChange);
  final VoidCallback onChange;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChange();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChange();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      onChange();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      onChange();
}

class _TabSwitcher extends StatelessWidget {
  const _TabSwitcher({required this.tabNotifier, required this.tabBuilder});

  final ValueNotifier<AppTab> tabNotifier;
  final Widget Function(BuildContext context, AppTab tab) tabBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppTab>(
      valueListenable: tabNotifier,
      builder: (context, tab, _) => tabBuilder(context, tab),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.current, required this.onSelect});

  final AppTab current;
  final ValueChanged<AppTab> onSelect;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current.index,
      onTap: (i) => onSelect(AppTab.values[i]),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_vert_rounded),
          label: 'Convert',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.star_rounded),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tune_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}
