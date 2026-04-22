import 'package:jccm_espacio_ciudadano/core/network/result.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/consent_state.dart';

/// Domain contract for consent persistence operations.
///
/// Implementations live in `3_data/`. This interface must not import any
/// Flutter, Riverpod, Dio, or concrete storage class — only entities and
/// [Result].
///
/// All methods return [Result] values instead of throwing so that callers
/// in `1_domain/` can pattern-match failures without catching exceptions.
abstract interface class ConsentRepository {
  /// Checks whether the user has previously accepted the consent.
  ///
  /// Returns [ConsentAccepted] if the stored value indicates acceptance,
  /// [ConsentPending] otherwise.
  Future<Result<ConsentState>> checkConsentAccepted();

  /// Persists the user's consent acceptance.
  ///
  /// Writes a flag to secure storage indicating the user has accepted.
  Future<Result<void>> acceptConsent();

  /// Persists the user's consent rejection.
  ///
  /// Writes a flag to secure storage indicating the user has rejected.
  Future<Result<void>> rejectConsent();
}
