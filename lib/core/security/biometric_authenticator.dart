import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

/// Abstraction over local biometric authentication.
abstract interface class BiometricAuthenticator {
  /// Returns `true` only when a biometric check succeeds.
  ///
  /// Face ID is prioritised when available; fingerprint is used as fallback.
  Future<bool> authenticateForSessionUnlock({
    required final String localizedReason,
  });
}

final class LocalBiometricAuthenticator implements BiometricAuthenticator {
  LocalBiometricAuthenticator(this._localAuth);

  final LocalAuthentication _localAuth;

  @override
  Future<bool> authenticateForSessionUnlock({
    required final String localizedReason,
  }) async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!isSupported || !canCheckBiometrics) {
        return false;
      }

      final available = await _localAuth.getAvailableBiometrics();
      final hasFaceId = available.contains(BiometricType.face);
      final hasFingerprint = available.contains(BiometricType.fingerprint);

      // Requirement priority: Face ID first, then fingerprint.
      if (!hasFaceId && !hasFingerprint) {
        return false;
      }

      return _localAuth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: true,
      );
    } on LocalAuthException catch (error, stackTrace) {
      if (_shouldReportAuthException(error.code)) {
        _reportBiometricAuthError(error, stackTrace);
      }
      return false;
    } catch (error, stackTrace) {
      _reportBiometricAuthError(error, stackTrace);
      return false;
    }
  }
}

bool _shouldReportAuthException(final LocalAuthExceptionCode code) {
  return switch (code) {
    LocalAuthExceptionCode.userCanceled || LocalAuthExceptionCode.systemCanceled || LocalAuthExceptionCode.timeout => false,
    _ => true,
  };
}

void _reportBiometricAuthError(final Object error, final StackTrace stackTrace) {
  FlutterError.reportError(
    FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'biometric_authenticator',
      context: ErrorDescription('while authenticating for session unlock'),
    ),
  );
}

final biometricAuthenticatorProvider = Provider<BiometricAuthenticator>((final ref) {
  return LocalBiometricAuthenticator(LocalAuthentication());
});
