import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/app_loading_indicator.dart';
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
      LandingState(loginSuccess: true) => Routes.lifeEventsOnboarding,
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

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginPageTitle)),
      body: AppLoadingIndicator(semanticsLabel: l10n.loginPageLoading),
    );
  }
}
