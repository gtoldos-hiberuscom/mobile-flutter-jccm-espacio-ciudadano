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
          'Autorizo la consulta de los hechos administrativos que obren en poder '
          'de la JCCM en materia de Bienestar social, Empleo, Educación y Salud '
          'para que se muestren en Espacio ciudadano.',
      isSelected: false,
    ),
    Clause(
      id: 2,
      label:
          'Autorizo la consulta de los datos que la Otras temas de interés tiene '
          'sobre mí para que se muestren en Espacio Ciudadano.',
      isSelected: false,
    ),
    Clause(
      id: 3,
      label:
          'Consiento que mis datos sean tratados para recibir recomendaciones '
          'relativas a trámites mediante la elaboración de un perfil basado '
          'exclusivamente en los hechos vitales que he marcado. Podrá retirar '
          'en cualquier momento desmarcando la autorización inicial en el '
          'apartado de perfil usuario.',
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
