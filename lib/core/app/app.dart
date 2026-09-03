import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_theme.dart';
import 'package:jccm_espacio_ciudadano/core/routing/app_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/consent_revocation_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Root widget of the application.
///
/// Wires together the router (via [goRouterProvider]), theme, and
/// localization delegates. All composition of top-level app concerns happens
/// here; no business logic belongs in this widget.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final appName = ref.watch(appConfigProvider).appName;

    // Retirada de la cláusula obligatoria: la sesión ya se ha cerrado, aquí
    // solo se saca al usuario de donde estuviera y se le explica por qué. El
    // aviso se aplaza al final del frame porque navegar durante un build de
    // GoRouter es exactamente cómo se cuelga la navegación.
    ref.listen<bool>(consentRevocationProvider, (final previous, final next) {
      if (!next || (previous ?? false)) {
        return;
      }
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        router.go(Routes.landing);
        // El aviso necesita un contexto por **debajo** del `ScaffoldMessenger`
        // y con las localizaciones ya instaladas: el del navegador del router
        // lo cumple, el de este widget no (es quien construye `MaterialApp`).
        final navigatorContext = router.routerDelegate.navigatorKey.currentContext;
        if (navigatorContext == null || !navigatorContext.mounted) {
          return;
        }
        AppAlertSnackbar.show(
          navigatorContext,
          message: AppLocalizations.of(navigatorContext).consentRevokedSessionClosed,
          severity: AppAlertSeverity.warning,
        );
      });
    });

    return MaterialApp.router(
      title: appName,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
    );
  }
}
