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
          'Cláusula inicial: autorizo el acceso básico a la información '
          'necesaria para usar Espacio Ciudadano.',
      isSelected: false,
    ),
    Clause(
      id: 2,
      label:
          'Cláusula JCCM: autorizo la consulta y tratamiento de información '
          'gestionada por la Junta de Comunidades de Castilla-La Mancha.',
      isSelected: false,
    ),
    Clause(
      id: 3,
      label:
          'Cláusula AGE: autorizo la consulta de información procedente de '
          'la Administración General del Estado cuando sea necesaria.',
      isSelected: false,
    ),
    Clause(
      id: 4,
      label:
          'Cláusula recomendaciones: autorizo el uso de mis preferencias y '
          'hechos vitales para recibir recomendaciones personalizadas.',
      isSelected: false,
    ),
  ];

  // ── ConsentRepository ──────────────────────────────────────────────────────

  @override
  Future<bool> hasAcceptedConsent({
    required final String idAgente,
  }) async => _storage.read<bool>(_key(idAgente)) ?? false;

  @override
  Future<void> markConsentAccepted({
    required final String idAgente,
    required final List<Clause> clauses,
  }) async {
    final acceptedClauseIds = clauses.where((final clause) => clause.isSelected).map((final clause) => clause.id.toString()).toList(growable: false);

    await _storage.write(_acceptedClausesKey(idAgente), acceptedClauseIds);
    await _storage.write(_key(idAgente), true);
  }

  @override
  Future<List<Clause>> fetchClauses() async => _fallbackClauses;

  // ── Private ───────────────────────────────────────────────────────────────

  String _key(final String idAgente) => '${StorageKeys.consentAcceptedPrefix}$idAgente';

  String _acceptedClausesKey(final String idAgente) => '${StorageKeys.consentAcceptedClausesPrefix}$idAgente';
}
