import 'package:jccm_espacio_ciudadano/core/auth/session_state_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_state.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_notifier.g.dart';

/// Riverpod [AsyncNotifier] that manages the full authentication lifecycle.
///
/// ## State machine
/// ```
/// AuthUnauthenticated ──login()──► AuthLoading ──success──► AuthAuthenticated
///                                               └─failure──► AuthError
/// AuthAuthenticated ──logout()──► AuthUnauthenticated
/// AuthAuthenticated ──checkAndRefresh()──[expired]──► AuthLoading
///                                         ├─success──► AuthAuthenticated
///                                         └─failure──► AuthExpired
/// ```
///
/// ## sessionStateProvider bridge
/// Every state transition also updates [sessionStateProvider] so that the
/// GoRouter guard reacts to authentication changes without knowing about
/// the auth feature's internal structure.
///
/// ## PII policy
/// Token values and [Session.idAgente] are never logged. All `debugPrint`
/// calls are omitted from this file intentionally.
@Riverpod(keepAlive: true)
class SessionNotifier extends _$SessionNotifier {
  @override
  Future<AuthState> build() async {
    final result = await ref.read(authRepositoryProvider).restoreSession();
    return switch (result) {
      Success(:final value) when value != null => _emitAuthenticated(value),
      _ => _emitUnauthenticated(),
    };
  }

  // ── Public actions ─────────────────────────────────────────────────────────

  /// Opens the Cl@ve portal URL in the platform browser to start the login
  /// flow. The actual session is received via [handleCallback].
  Future<void> login(final String claveLoginUrl) async {
    state = const AsyncValue.data(AuthLoading());
    // initiateClaveLogin opens the browser. It returns Failure because the
    // token is not available yet — the real session arrives via handleCallback.
    // We intentionally stay in AuthLoading while the browser is open.
    await ref.read(authRepositoryProvider).initiateClaveLogin(claveLoginUrl);
  }

  /// Processes the deep-link [uri] received from the Cl@ve callback.
  ///
  /// Should be called by the router when it handles the `/auth/clave/callback`
  /// deep link. On success, persists the session and transitions to
  /// [AuthAuthenticated].
  Future<void> handleCallback(final Uri uri) async {
    state = const AsyncValue.data(AuthLoading());
    final result = await ref.read(authRepositoryProvider).handleCallback(uri);
    state = switch (result) {
      Success(:final value) => AsyncValue.data(_emitAuthenticated(value)),
      Failure(:final error) => AsyncValue.data(AuthError(error.message)),
    };
  }

  /// Clears the session and transitions to [AuthUnauthenticated].
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = AsyncValue.data(_emitUnauthenticated());
  }

  /// Checks if the current session is expired and attempts a silent refresh.
  ///
  /// If refresh succeeds, stays in [AuthAuthenticated].
  /// If refresh fails or the session is expired and unrecoverable, emits
  /// [AuthExpired].
  Future<void> checkAndRefresh() async {
    final current = state.value;
    if (current is! AuthAuthenticated) {
      return;
    }

    final session = current.session;
    if (!session.isExpired) {
      return;
    }

    state = const AsyncValue.data(AuthLoading());
    final result = await ref.read(authRepositoryProvider).refreshSession(session);
    state = switch (result) {
      Success() => AsyncValue.data(_emitAuthenticated(session)),
      Failure() => AsyncValue.data(_emitExpired()),
    };
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  AuthAuthenticated _emitAuthenticated(final Session session) {
    // Bridge: keep the legacy sessionStateProvider in sync so the GoRouter
    // guard can read session state without depending on this notifier.
    ref.read(sessionStateProvider.notifier).establish(session.idAgente);
    return AuthAuthenticated(session);
  }

  AuthUnauthenticated _emitUnauthenticated() {
    ref.read(sessionStateProvider.notifier).invalidate();
    return const AuthUnauthenticated();
  }

  AuthExpired _emitExpired() {
    ref.read(sessionStateProvider.notifier).invalidate();
    return const AuthExpired();
  }
}
