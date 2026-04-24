import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/core/auth/session_state_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_notifier.dart';

/// Navigation guard based on session state.
///
/// All redirect logic reads from sessionStateProvider via a captured Ref
/// so that no BuildContext ever enters the guard. GoRouter passes a context
/// that is intentionally ignored here — use `ref.read` for all state access.
///
/// Return `null`  → allow navigation to proceed.
/// Return a path  → redirect the user to that path.
final class SessionGuard {
  const SessionGuard(this._ref);

  final Ref _ref;

  /// Whether the app is currently in maintenance mode.
  ///
  /// Placeholder flag — replace with a backend-driven feature flag when the
  /// maintenance domain is implemented.
  bool get _maintenanceMode => false;

  /// GoRouter redirect callback.
  ///
  /// Called on every navigation attempt. The BuildContext parameter is
  /// required by the GoRouter API but is deliberately ignored to keep guards
  /// free of UI concerns.
  String? redirect(final GoRouterState state) {
    final location = state.matchedLocation;
    final session = _ref.read(sessionStateProvider);
    final isAuthenticated = session != null;

    // ── Maintenance gate (highest priority) ──────────────────────────────────
    if (_maintenanceMode && location != Routes.maintenance) {
      return Routes.maintenance;
    }

    // ── Auth gate ────────────────────────────────────────────────────────────
    final needsAuth = Routes.requiresAuth(location);

    if (needsAuth && !isAuthenticated) {
      return Routes.landing;
    }

    // ── Consent gate (post-auth, pre-home) ───────────────────────────────────
    // After authentication is confirmed, if consent has not been accepted,
    // redirect to the consent screen. This gate is skipped for:
    // - the consent screen itself (prevent infinite loop)
    // - callbacks, legal pages, and other non-functional routes
    if (isAuthenticated && location != Routes.consent) {
      final isCallback = location.startsWith('/auth/') || location.startsWith('/sign/') || location.startsWith('/login') || location.startsWith('/legal') || location == Routes.sitemap || location == Routes.help || location == Routes.maintenance;

      if (!isCallback) {
        final consentAsync = _ref.read(consentProvider);
        final consentState = consentAsync.value;
        // Only redirect when consent state is definitively Pending.
        // If still loading (null) or Accepted, allow through.
        if (consentState is ConsentPending) {
          return Routes.consent;
        }
      }
    }

    // ── Reverse gate (already logged-in on public route) ─────────────────────
    if (!needsAuth && isAuthenticated) {
      // Allow deep-link callbacks, legal pages, and consent through.
      final isCallback = location.startsWith('/auth/') || location.startsWith('/sign/') || location.startsWith('/login') || location.startsWith('/legal') || location == Routes.sitemap || location == Routes.help || location == Routes.maintenance || location == Routes.consent;

      if (!isCallback && location != Routes.home) {
        return Routes.home;
      }
    }

    return null; // allow
  }
}
