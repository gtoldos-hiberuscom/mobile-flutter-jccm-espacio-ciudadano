import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/app/localization/localization.dart';
import 'package:jccm_espacio_ciudadano/app/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_theme.dart';

/// Root widget of the application.
///
/// Wires together the router, theme, and localization delegates.
/// All composition of top-level app concerns happens here.
class App extends StatefulWidget {
  const App({required this.config, super.key});

  final AppConfig config;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter();
  }

  @override
  void dispose() {
    _appRouter.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => MaterialApp.router(
        title: widget.config.appName,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        routerConfig: _appRouter.router,
        localizationsDelegates: AppLocalization.delegates,
        supportedLocales: AppLocalization.supportedLocales,
      );
}
