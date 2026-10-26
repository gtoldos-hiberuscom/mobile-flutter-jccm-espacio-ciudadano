import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

/// Copy for the Android biometric prompt.
///
/// Android renders its own dialog and takes the strings from the caller; iOS
/// uses the system prompt plus `NSFaceIDUsageDescription` from `Info.plist`
/// and ignores this. Passed in from the presentation layer because
/// `lib/core` has no access to `AppLocalizations`.
final class BiometricPromptCopy {
  const BiometricPromptCopy({
    required this.title,
    required this.subtitle,
    required this.cancelLabel,
  });

  final String title;
  final String subtitle;
  final String cancelLabel;
}

/// Abstraction over local biometric authentication.
abstract interface class BiometricAuthenticator {
  /// Returns `true` when the device has an enrolled biometric authenticator.
  Future<bool> canAuthenticateWithBiometrics();

  /// Returns `true` only when a biometric check succeeds.
  ///
  /// Uses the enrolled biometric type selected by the platform prompt.
  /// [title] and [cancelLabel] only apply to Android, whose dialog otherwise
  /// shows the plugin's English defaults; iOS uses the system prompt.
  Future<bool> authenticateForSessionUnlock({
    required final String localizedReason,
    final String? title,
    final String? cancelLabel,
  });
}

final class LocalBiometricAuthenticator implements BiometricAuthenticator {
  LocalBiometricAuthenticator(this._localAuth);

  final LocalAuthentication _localAuth;

  @override
  Future<bool> canAuthenticateWithBiometrics() async {
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!isSupported || !canCheckBiometrics) {
        return false;
      }

      final available = await _localAuth.getAvailableBiometrics();
      return _hasSupportedBiometric(available);
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

  @override
  Future<bool> authenticateForSessionUnlock({
    required final String localizedReason,
    final String? title,
    final String? cancelLabel,
  }) async {
    try {
      final available = await _localAuth.getAvailableBiometrics();
      if (!_hasSupportedBiometric(available)) {
        return false;
      }

      // `await` y no devolver el Future tal cual: sin él la cancelación
      // (`LocalAuthException.userCanceled`) se escapaba del `catch` de abajo
      // como error sin capturar, en vez de convertirse en `false`.
      return await _localAuth.authenticate(
        localizedReason: localizedReason,
        authMessages: [AndroidAuthMessages(signInTitle: title, cancelButton: cancelLabel)],
        biometricOnly: true,
        persistAcrossBackgrounding: true,
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

bool _hasSupportedBiometric(final List<BiometricType> available) {
  return available.any(
    (final type) => switch (type) {
      BiometricType.face || BiometricType.fingerprint || BiometricType.iris || BiometricType.strong || BiometricType.weak => true,
    },
  );
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
