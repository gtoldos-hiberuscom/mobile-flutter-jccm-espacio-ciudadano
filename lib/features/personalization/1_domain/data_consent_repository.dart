import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';

/// Result of loading the data-consent (`clausulas`) catalog from the backend.
///
/// Holds the catalog of [items] (one per [DataConsentType]) together with
/// the citizen's currently persisted acceptance per id, so the notifier can
/// seed both the draft and the baseline used for dirty detection.
final class DataConsentLoadResult {
  const DataConsentLoadResult({
    required this.items,
  });

  final List<DataConsent> items;
}

/// Domain contract for the data-consent screen (STORY-55).
///
// TODO(STORY-55): Sprint-4 implementation returns mocked data. Real Dio
/// wiring against `/hechos-vitales/clausulas/{idAgente}` (GET catalog),
/// `PATCH /hechos-vitales/clausulas` (persist consents) and
/// `/hechos-vitales/preferencias/{idAgente}` (DELETE revoke) is owned by
/// a follow-up story (depends on TASK-21 idAgente closure).
abstract interface class DataConsentRepository {
  Future<DataConsentLoadResult> loadClausulas(final String idAgente);

  Future<void> saveClausulas(
    final String idAgente,
    final Map<DataConsentType, bool> acceptance,
  );

  Future<void> revokeAll(final String idAgente);
}
