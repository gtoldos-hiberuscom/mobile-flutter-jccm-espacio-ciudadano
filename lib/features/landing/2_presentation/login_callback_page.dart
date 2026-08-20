import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
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

  @override
  ConsumerState<LoginCallbackPage> createState() => _LoginCallbackPageState();
}

class _LoginCallbackPageState extends ConsumerState<LoginCallbackPage> {
  bool _navigationScheduled = false;

  void _navigateWhenLoginCompletes(final LandingState state) {
    final String? destination = switch (state) {
      LandingState(loginSuccess: true) => Routes.home,
      LandingState(error: != null) => Routes.landing,
      _ => null,
    };
    if (destination == null || _navigationScheduled) {
      return;
    }

    _navigationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(destination);
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
    return Scaffold(
      body: AppLoadingScreen(
        title: l10n.loginPageTitle,
        description: l10n.loginPageLoadingDescription,
      ),
    );
  }
}
