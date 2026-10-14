import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/security/biometric_authenticator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';

void main() {
  test('REGRESSION: cancelar la huella devuelve false en vez de escaparse como error', () async {
    // Devolver el Future de `authenticate` sin `await` dejaba la cancelación
    // fuera del `catch`: en el emulador salía «Unhandled Exception:
    // LocalAuthException(code userCanceled)».
    final authenticator = LocalBiometricAuthenticator(_CancellingLocalAuth());

    expect(await authenticator.authenticateForSessionUnlock(localizedReason: 'r'), isFalse);
  });

  test('pasa a Android la copia del diálogo', () async {
    final localAuth = _CancellingLocalAuth()..cancel = false;
    final authenticator = LocalBiometricAuthenticator(localAuth);

    expect(await authenticator.authenticateForSessionUnlock(localizedReason: 'r', title: 't', cancelLabel: 'c'), isTrue);
    final messages = localAuth.lastMessages!.whereType<AndroidAuthMessages>().single;
    expect(messages.signInTitle, 't');
    expect(messages.cancelButton, 'c');
  });
}

final class _CancellingLocalAuth extends Fake implements LocalAuthentication {
  bool cancel = true;
  Iterable<AuthMessages>? lastMessages;

  @override
  Future<List<BiometricType>> getAvailableBiometrics() async => const [BiometricType.strong];

  @override
  Future<bool> authenticate({
    required final String localizedReason,
    final Iterable<AuthMessages> authMessages = const <AuthMessages>[],
    final bool biometricOnly = false,
    final bool sensitiveTransaction = true,
    final bool persistAcrossBackgrounding = false,
  }) async {
    lastMessages = authMessages;
    if (cancel) {
      throw const LocalAuthException(code: LocalAuthExceptionCode.userCanceled);
    }
    return true;
  }
}
