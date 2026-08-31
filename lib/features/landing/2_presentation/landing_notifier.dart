import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/citizen_endpoint_ids_provider.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';

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
        ref.read(authSessionControllerProvider).startInMemory(tokenResponse, claims: jwtClaims);
        ref.invalidate(consentProvider(ref.read(citizenEndpointIdsProvider).idAgente ?? ''));
        state = const LandingState(loginSuccess: true);

      case LoginFailed(:final cause):
        // The user only ever sees a curated generic message; this log line is
        // the sole record of the real OAuth error/error_description.
        logger.e('Cl@ve login failed: $cause');
        if (cause is AuthException) {
          // Cancellations are silent — user deliberately dismissed the flow.
          state = cause.reason == AuthFailureReason.cancelled ? const LandingState() : LandingState(error: cause);
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
