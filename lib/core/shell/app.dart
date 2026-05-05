import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/core/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_theme.dart';

/// Root widget of the application.
///
/// Wires together the router (via [goRouterProvider]), theme, and
/// localization delegates. All composition of top-level app concerns happens
/// here; no business logic belongs in this widget.
class App extends ConsumerWidget {
  const App({required this.config, super.key});

  final AppConfig config;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: config.appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      localizationsDelegates: AppLocalization.delegates,
      supportedLocales: AppLocalization.supportedLocales,
    );
  }
}
