import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';
import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/consent_state.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_repository.dart';

/// Concrete [SecureStorage]-backed implementation of [ConsentRepository].
///
/// ## Storage contract
/// - Key: [StorageKeys.consentAccepted]
/// - Accepted value: `'1'`
/// - Rejected / absent: anything else or `null`
///
/// ## PII policy
/// Consent is a simple boolean flag with no PII. It is still stored in
/// [SecureStorage] to keep all persistent state in one encrypted store.
final class ConsentRepositoryImpl implements ConsentRepository {
  const ConsentRepositoryImpl(this._secureStorage);

  final SecureStorage _secureStorage;

  // ── checkConsentAccepted ──────────────────────────────────────────────────

  @override
  Future<Result<ConsentState>> checkConsentAccepted() async {
    try {
      final value =
          await _secureStorage.read(StorageKeys.consentAccepted);
      final state =
          value == '1' ? const ConsentAccepted() : const ConsentPending();
      return Success(state);
    } catch (_) {
      return const Failure(
        UnknownError(message: 'Error al verificar el consentimiento.'),
      );
    }
  }

  // ── acceptConsent ─────────────────────────────────────────────────────────

  @override
  Future<Result<void>> acceptConsent() async {
    try {
      await _secureStorage.write(StorageKeys.consentAccepted, '1');
      return const Success(null);
    } catch (_) {
      return const Failure(
        UnknownError(message: 'Error al guardar la aceptación del consentimiento.'),
      );
    }
  }

  // ── rejectConsent ─────────────────────────────────────────────────────────

  @override
  Future<Result<void>> rejectConsent() async {
    try {
      await _secureStorage.write(StorageKeys.consentAccepted, '0');
      return const Success(null);
    } catch (_) {
      return const Failure(
        UnknownError(message: 'Error al guardar el rechazo del consentimiento.'),
      );
    }
  }
}
