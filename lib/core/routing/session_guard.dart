import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_accepted_consent_clause_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_consent_required_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';
import 'package:meta/meta.dart';

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
  Future<String?> redirect(final GoRouterState state) => redirectPath(state.matchedLocation);

  /// Testable core of [redirect]: `GoRouterState` cannot be constructed in
  /// unit tests, so the decision logic works on the matched location alone.
  @visibleForTesting
  Future<String?> redirectPath(final String path) async {
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
  /// current consent version. Returns `null` when consent is already on record
  /// — and also when the consent status cannot be determined (backend
  /// unavailable): the gate fails OPEN because it is enforced server-side too,
  /// and treating an outage as "not accepted" would destroy valid sessions.
  Future<String?> _consentRedirect(final String path) async {
    final String idAgente = _ref.read(citizenEndpointIdsProvider).idAgente ?? '';
    if (idAgente.isEmpty) {
      return null;
    }

    final result = await _ref.read(checkConsentRequiredUsecaseProvider).execute(idAgente: idAgente);

    switch (result) {
      case CheckConsentRequiredFailed(:final message):
        logger.e('Consent gate unavailable — failing open: $message');
        return null;

      case ConsentRequired():
        final sessionController = _ref.read(authSessionControllerProvider);
        if (await sessionController.hasPersistedSession()) {
          logger.w('Consent gate: remote reports consent not accepted — clearing persisted session');
          await sessionController.clear();
          return Routes.landing;
        }
        // Allow legal-gate pages themselves — prevents infinite redirect loops
        // for the temporary in-memory session created immediately after login.
        if (path == Routes.consent || path == Routes.legalPrivacy) {
          return null;
        }
        return Routes.legalPrivacy;

      case ConsentNotRequired():
        if (path == Routes.consent || path == Routes.legalPrivacy) {
          return null;
        }
        return _optionalConsentRedirect(path);
    }
  }

  Future<String?> _optionalConsentRedirect(final String path) async {
    final String idAgente = _ref.read(citizenEndpointIdsProvider).idAgente ?? '';
    if (idAgente.isEmpty) {
      return null;
    }

    final requiredClauseId = _requiredOptionalClauseId(path);
    if (requiredClauseId == null) {
      return null;
    }

    final hasAcceptedClause = await _hasAcceptedClause(idAgente, requiredClauseId);
    if (hasAcceptedClause) {
      return null;
    }

    return Uri(
      path: Routes.consent,
      queryParameters: {
        'mode': 'preferences',
        'returnTo': path,
      },
    ).toString();
  }

  int? _requiredOptionalClauseId(final String path) {
    if (path == Routes.myDataEmploymentOffers || path.startsWith(Routes.myDataSocialWelfareFamily) || path.startsWith(Routes.myDataSocialWelfareDisability) || path.startsWith(Routes.myDataSocialWelfareThermalSpa) || path.startsWith(Routes.myDataSocialWelfareDependency) || path.startsWith(Routes.myDataSocialWelfareParking)) {
      return jccmDataConsentClauseId;
    }

    if (path.startsWith(Routes.myDataEducationUniversityTitles) || path.startsWith(Routes.myDataEducationNonUniversityTitles) || path.startsWith(Routes.myDataHousingRealEstate) || path.startsWith(Routes.myDataHousingAddress)) {
      return ageDataConsentClauseId;
    }

    return null;
  }

  Future<bool> _hasAcceptedClause(final String idAgente, final int clauseId) async {
    final result = await _ref
        .read(checkAcceptedConsentClauseUsecaseProvider)
        .execute(
          idAgente: idAgente,
          clauseId: clauseId,
        );
    switch (result) {
      case AcceptedConsentClauseStatus(:final isAccepted):
        return isAccepted;
      case CheckAcceptedConsentClauseFailed(:final message):
        // Fail open: with the backend unavailable, detouring into the
        // preferences consent editor (whose clause load would also fail) is a
        // dead end; the destination page shows its own error state.
        logger.e('Optional clause $clauseId check unavailable — failing open: $message');
        return true;
    }
  }
}
