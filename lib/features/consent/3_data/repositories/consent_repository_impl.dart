import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

/// AppStorage-backed implementation of [ConsentRepository].
///
/// Consent acceptance is persisted per citizen (keyed by [idAgente]) using
/// SharedPreferences. Clause content is served from a hardcoded static list
/// that acts as the canonical fallback until a versioned remote catalogue is
/// introduced in a future ticket.
final class ConsentRepositoryImpl implements ConsentRepository {
  const ConsentRepositoryImpl(this._storage);
  final AppStorage _storage;

  // ── Fallback clause catalogue ─────────────────────────────────────────────
  //
  // Labels are legal text validated by the JCCM legal team. Version '1.0'
  // is the initial release. Update the version string to force re-consent
  // when the text changes.
  static const _fallbackClauses = [
    Clause(
      id: 1,
      label:
          'Autorizo el acceso y tratamiento de mis datos personales por parte '
          'de la Junta de Comunidades de Castilla-La Mancha para la prestación '
          'de los servicios del Espacio Ciudadano.',
      isSelected: false,
    ),
    Clause(
      id: 2,
      label:
          'Autorizo la consulta de mis datos en otros organismos y '
          'administraciones públicas cuando sea necesario para completar los '
          'servicios disponibles.',
      isSelected: false,
    ),
    Clause(
      id: 3,
      label:
          'Consiento el uso de mis hechos vitales para la personalización de '
          'contenidos y recomendaciones en el Espacio Ciudadano.',
      isSelected: false,
    ),
  ];

  // ── ConsentRepository ──────────────────────────────────────────────────────

  @override
  Future<bool> hasAcceptedConsent({
    required final String idAgente,
  }) async =>
      _storage.read<bool>(_key(idAgente)) ?? false;

  @override
  Future<void> markConsentAccepted({
    required final String idAgente,
  }) =>
      _storage.write(_key(idAgente), true);

  @override
  Future<List<Clause>> fetchClauses() async => _fallbackClauses;

  // ── Private ───────────────────────────────────────────────────────────────

  String _key(final String idAgente) =>
      '${StorageKeys.consentAcceptedPrefix}$idAgente';
}
