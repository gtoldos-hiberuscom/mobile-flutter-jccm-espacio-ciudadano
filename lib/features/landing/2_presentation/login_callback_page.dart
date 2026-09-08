import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/landing/2_presentation/landing_notifier.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Transitional surface shown if Flutter receives the Cl@ve callback URI.
///
/// `flutter_appauth` completes the token exchange asynchronously. Keep
/// observing the landing login state here because the callback deep link can
/// replace the landing page before its listener sees the successful response.
class LoginCallbackPage extends ConsumerStatefulWidget {
  const LoginCallbackPage({super.key});

  /// Grace period when no login is in flight in this isolate — the deep link
  /// relaunched a dead process, so nothing will ever complete here.
  static const neutralGrace = Duration(seconds: 3);

  /// Ceiling for an in-flight token exchange to publish a result.
  static const inFlightGrace = Duration(seconds: 60);

  @override
  ConsumerState<LoginCallbackPage> createState() => _LoginCallbackPageState();
}

class _LoginCallbackPageState extends ConsumerState<LoginCallbackPage> {
  bool _navigationScheduled = false;
  Timer? _watchdog;

  @override
  void initState() {
    super.initState();
    final landingState = ref.read(landingProvider);
    final isLoginInFlight = landingState.isLoggingIn || landingState.loginSuccess || landingState.error != null;
    // Without this timer, a callback URI that arrives with nothing in flight
    // renders the loading veil permanently: no state transition will ever
    // produce a destination, and the veil offers no user action.
    _watchdog = Timer(
      isLoginInFlight ? LoginCallbackPage.inFlightGrace : LoginCallbackPage.neutralGrace,
      _abortToLanding,
    );
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    super.dispose();
  }

  void _abortToLanding() {
    if (!mounted || _navigationScheduled) {
      return;
    }
    logger.w('Login callback watchdog fired — returning to landing');
    _navigationScheduled = true;
    ref.read(landingProvider.notifier).consumeLoginSuccess();
    context.go(Routes.landing);
  }

  void _navigateWhenLoginCompletes(final LandingState state) {
    final String? destination = switch (state) {
      LandingState(loginSuccess: true) => Routes.home,
      LandingState(error: != null) => Routes.landing,
      _ => null,
    };
    if (destination == null || _navigationScheduled) {
      return;
    }

    _watchdog?.cancel();
    _navigationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(destination);
        // The landing page consumes the one-shot in its own dispose, but when
        // the deep link replaced it before login completed, this page is the
        // only consumer left standing.
        ref.read(landingProvider.notifier).consumeLoginSuccess();
      }
    });
  }

  @override
  Widget build(final BuildContext context) {
    final state = ref.watch(landingProvider);
    final l10n = AppLocalizations.of(context);

    ref.listen<LandingState>(
      landingProvider,
      (final previous, final next) => _navigateWhenLoginCompletes(next),
    );
    _navigateWhenLoginCompletes(state);

    // Mismo velo que la landing, para que el regreso de Cl@ve se vea igual
    // llegue por donde llegue el deep link.
    // Sin AppBar, esta página hereda el estilo que dejó la home pública
    // (iconos oscuros), que sobre el velo azul oscuro se veían tapados.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: AppLoadingScreen(
          title: l10n.loginPageTitle,
          description: l10n.loginPageLoadingDescription,
        ),
      ),
    );
  }
}
