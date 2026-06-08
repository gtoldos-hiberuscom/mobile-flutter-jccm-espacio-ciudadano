import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_session_controller.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_use_case_providers.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/usecases/check_consent_required_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/controllers/consent_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/2_presentation/providers/consent_usecase_providers.dart';

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

    final biometricQuickAccessEnabled = ref.read(appStorageProvider).read<bool>(StorageKeys.biometricQuickAccessEnabled) ?? false;
    if (!biometricQuickAccessEnabled) {
      return;
    }

    final secureStorage = ref.read(secureStorageProvider);
    final storedAccessToken = await secureStorage.read(StorageKeys.accessToken);
    if (storedAccessToken == null || storedAccessToken.isEmpty) {
      return;
    }

    final isAuthenticatedBiometrically = await ref.read(biometricAuthenticatorProvider).authenticateForSessionUnlock(localizedReason: localizedReason);
    if (!isAuthenticatedBiometrically || !ref.mounted) {
      return;
    }

    final session = await ref.read(authSessionControllerProvider).hydrateFromStorage();
    final jwtClaims = ref.read(authSessionControllerProvider).currentClaims;
    if (session == null || jwtClaims == null) {
      return;
    }
    final consentResult = await ref.read(checkConsentRequiredUsecaseProvider).execute(idAgente: jwtClaims.idAgente ?? '');
    if (!ref.mounted) {
      return;
    }
    if (consentResult is ConsentRequired) {
      await ref.read(authSessionControllerProvider).clear();
      return;
    }
    ref.invalidate(consentProvider(jwtClaims.idAgente ?? ''));
    state = const LandingState(loginSuccess: true);
  }

  Future<void> login() async {
    if (state.isLoggingIn) {
      return;
    }
    state = const LandingState(isLoggingIn: true);

    final appStorage = ref.read(appStorageProvider);
    final forceClaveLogin = appStorage.read<bool>(StorageKeys.forceClaveLoginOnNextLogin) ?? false;
    final result = await ref.read(loginUseCaseProvider).call(forceLogin: forceClaveLogin);

    if (!ref.mounted) {
      return;
    }

    switch (result) {
      case LoginSuccess(:final tokenResponse, :final jwtClaims):
        if (forceClaveLogin) {
          await appStorage.remove(StorageKeys.forceClaveLoginOnNextLogin);
          if (!ref.mounted) {
            return;
          }
        }
        ref.read(authSessionControllerProvider).startInMemory(tokenResponse, claims: jwtClaims);
        ref.invalidate(consentProvider(jwtClaims.idAgente ?? ''));
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
