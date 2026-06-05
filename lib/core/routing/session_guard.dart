import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_consent_required_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/check_life_events_onboarding_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/onboarding_preferences_usecase_providers.dart';

/// Route guard that enforces session validity before any authenticated route
/// is entered.
///
/// The guard is designed to be instantiated inside the `goRouterProvider`
/// factory so it captures the provider's `Ref` without relying on
/// `BuildContext`. This makes it unit-testable in isolation.
///
/// ## Decision flow
///
/// 1. If the target route does not require auth → pass through (`null`).
/// 2. Ask `AuthSessionController` to hydrate/validate the session.
/// 3. Expired sessions are refreshed silently.
/// 4. Missing or invalid sessions are cleared and redirected to landing.
///
/// No transport-level error details are surfaced to the user.
final class SessionGuard {
  const SessionGuard(this._ref);

  final Ref _ref;

  /// Returns the redirect target or `null` to allow navigation to proceed.
  Future<String?> redirect(final GoRouterState state) async {
    final String path = state.matchedLocation;

    // Public routes — always allow.
    if (!Routes.requiresAuth(path)) {
      return null;
    }

    final sessionController = _ref.read(authSessionControllerProvider);

    // ── Step 1: determine current expiry ─────────────────────────────────────

    final isValid = await sessionController.refreshIfNeeded();
    if (!isValid) {
      return Routes.landing;
    }
    return _consentRedirect(path);
  }

  /// Enforces the mandatory legal-consent gate (JCCMEC-11).
  ///
  /// Returns [Routes.consent] when the citizen has not yet accepted the
  /// current consent version. Returns `null` (or delegates to
  /// [_onboardingRedirect]) when consent is already on record.
  Future<String?> _consentRedirect(final String path) async {
    final String idAgente = _ref.read(jwtClaimsProvider)?.idAgente ?? '';
    if (idAgente.isEmpty) {
      return _onboardingRedirect(path);
    }

    final result = await _ref.read(checkConsentRequiredUsecaseProvider).execute(idAgente: idAgente);

    if (result is ConsentRequired) {
      final sessionController = _ref.read(authSessionControllerProvider);
      if (await sessionController.hasPersistedSession()) {
        await sessionController.clear();
        return Routes.landing;
      }
      // Allow legal-gate pages themselves — prevents infinite redirect loops
      // for the temporary in-memory session created immediately after login.
      if (path == Routes.consent || path == Routes.legalPrivacy) {
        return null;
      }
      return Routes.legalPrivacy;
    }
    if (path == Routes.consent || path == Routes.legalPrivacy) {
      return null;
    }
    return _onboardingRedirect(path);
  }

  /// Redirects to the life-events onboarding screen on first login.
  ///
  /// Returns [Routes.lifeEvents] if the citizen has not yet seen the screen,
  /// or `null` to allow navigation to proceed normally once completed.
  Future<String?> _onboardingRedirect(final String path) async {
    if (path == Routes.lifeEvents) {
      return null;
    }
    final String idAgente = _ref.read(jwtClaimsProvider)?.idAgente ?? '';
    if (idAgente.isEmpty) {
      return null;
    }
    final result = await _ref.read(checkLifeEventsOnboardingUsecaseProvider).execute(idAgente: idAgente);
    switch (result) {
      case CheckLifeEventsOnboardingFailed():
        return Routes.lifeEventsOnboarding;
      case CheckLifeEventsOnboardingSuccess(:final hasSeen):
        if (!hasSeen) {
          return Routes.lifeEventsOnboarding;
        }
        return null;
    }
  }
}
