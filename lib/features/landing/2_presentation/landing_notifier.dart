import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_decoder.dart';
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
  bool _autoUnlockAttempted = false;

  @override
  LandingState build() => const LandingState();

  Future<void> tryUnlockStoredSession({
    required final String localizedReason,
  }) async {
    if (_autoUnlockAttempted) {
      return;
    }
    _autoUnlockAttempted = true;

    final secureStorage = ref.read(secureStorageProvider);
    final storedAccessToken = await secureStorage.read(StorageKeys.accessToken);
    if (storedAccessToken == null || storedAccessToken.isEmpty) {
      return;
    }

    final isAuthenticatedBiometrically = await ref.read(biometricAuthenticatorProvider).authenticateForSessionUnlock(localizedReason: localizedReason);
    if (!isAuthenticatedBiometrically || !ref.mounted) {
      return;
    }

    final storedRefreshToken = await secureStorage.read(StorageKeys.refreshToken);
    final storedSessionExpiry = await secureStorage.read(StorageKeys.sessionExpiresAt);

    ref
        .read(tokenResponseProvider.notifier)
        .update(
          TokenResponse(
            storedAccessToken,
            storedRefreshToken,
            storedSessionExpiry != null ? DateTime.tryParse(storedSessionExpiry) : null,
            null,
            null,
            null,
            null,
          ),
        );
    final jwtClaims = JwtDecoder.decode(storedAccessToken);
    ref.read(jwtClaimsProvider.notifier).update(jwtClaims.sub.isNotEmpty ? jwtClaims : null);
    state = const LandingState(loginSuccess: true);
  }

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
