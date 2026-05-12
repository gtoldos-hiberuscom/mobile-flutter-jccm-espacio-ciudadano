import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/token_response_notifier.dart';

/// UI state for the public landing screen login flow.
final class LandingState {
  const LandingState({
    this.isLoggingIn = false,
    this.error,
    this.loginSuccess = false,
  });

  final bool isLoggingIn;

  /// Non-null when login failed with a non-cancellation error.
  final AuthException? error;

  /// One-shot signal consumed by the page to trigger navigation.
  final bool loginSuccess;
}

/// Owns the login flow state for the public landing screen.
///
/// Orchestration: UI -> login() -> [LoginUseCase] -> notifier updates -> [LandingState].
/// Navigation is triggered by the page via `ref.listen` on `loginSuccess`.
class LandingNotifier extends Notifier<LandingState> {
  @override
  LandingState build() => const LandingState();

  Future<void> login() async {
    if (state.isLoggingIn) {
      return;
    }
    state = const LandingState(isLoggingIn: true);

    final result = await ref.read(loginUseCaseProvider).call();

    if (!ref.mounted) {
      return;
    }

    switch (result) {
      case LoginSuccess(:final tokenResponse, :final jwtClaims):
        // Persist in-memory session state — this is the caller's responsibility
        // now that LoginUseCase is decoupled from Riverpod notifiers.
        ref.read(tokenResponseProvider.notifier).update(tokenResponse);
        ref.read(jwtClaimsProvider.notifier).update(jwtClaims);
        state = const LandingState(loginSuccess: true);

      case LoginFailed(:final cause):
        if (cause is AuthException) {
          // Cancellations are silent — user deliberately dismissed the flow.
          state = cause.reason == AuthFailureReason.cancelled
              ? const LandingState()
              : LandingState(error: cause);
        } else {
          state = LandingState(
            error: AuthException.unexpected(cause: cause),
          );
        }
    }
  }

  void clearError() => state = const LandingState();
}

final landingProvider = NotifierProvider<LandingNotifier, LandingState>(LandingNotifier.new);
