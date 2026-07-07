import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';

/// Hybrid implementation of [ConsentRepository] using both API and local storage.
///
/// Consent acceptance is persisted per citizen via the Hechos Vitales API using
/// raw Dio POST requests (bypassing built_value serialization issues).
/// Local storage (SharedPreferences) is used as cache and fallback.
final class ConsentRepositoryImpl implements ConsentRepository {
  ConsentRepositoryImpl({
    required final AppStorage storage,
    required final Dio dio,
  }) : _storage = storage,
       _dio = dio;

  final AppStorage _storage;
  final Dio _dio;

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
          'para que se muestren en Espacio Ciudadano.',
      isSelected: false,
    ),
    Clause(
      id: 2,
      label:
          'Autorizo la consulta de los datos que la Administración General del Estado '
          'tiene sobre mí para que se muestren en Espacio Ciudadano.',
      isSelected: false,
    ),
    Clause(
      id: 3,
      label:
          'Consiento que mis datos sean tratados para recibir recomendaciones '
          'relativas a trámites mediante la elaboración de un perfil basado '
          'exclusivamente en los hechos vitales que he marcado. Podrá retirar '
          'en cualquier momento desmarcando la autorización inicial '
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

    // Persist locally first (offline support)
    await _storage.write(_acceptedClausesKey(idAgente), acceptedClauseIds);
    await _storage.write(_key(idAgente), true);

    // Then sync with API using raw JSON maps (bypassing built_value
    // serialization, which does not match the backend envelope here).
    try {
      final requestBody = <String, dynamic>{
        'idAgente': idAgente,
        'clausulas': clauses
            .map(
              (final clause) => <String, dynamic>{
                'idClausula': clause.id,
                'seleccionado': clause.isSelected,
                'version': clause.version,
              },
            )
            .toList(),
      };

      await _syncClauses(requestBody);
    } catch (e, stackTrace) {
      logger.e('Failed to sync clausulas with API: $e', stackTrace: stackTrace);
      // API error is non-fatal - local data already saved
      // In production, consider logging this error
    }
  }

  @override
  Future<bool> hasAcceptedClause({
    required final String idAgente,
    required final int clauseId,
  }) async {
    final acceptedClauseIds = _storage.read<List<String>>(_acceptedClausesKey(idAgente)) ?? const [];
    return acceptedClauseIds.contains(clauseId.toString());
  }

  @override
  Future<List<Clause>> fetchClauses() async => _fallbackClauses;

  // ── Private ───────────────────────────────────────────────────────────────

  String _key(final String idAgente) => '${StorageKeys.consentAcceptedPrefix}$idAgente';

  String _acceptedClausesKey(final String idAgente) => '${StorageKeys.consentAcceptedClausesPrefix}$idAgente';

  Future<void> _syncClauses(final Map<String, dynamic> requestBody) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/api/v1/hechos-vitales/clausulas',
        data: requestBody,
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (error) {
      if (!_shouldRetryAsUpdate(error.response?.statusCode)) {
        rethrow;
      }

      await _dio.patch<Map<String, dynamic>>(
        '/api/v1/hechos-vitales/clausulas',
        data: requestBody,
        options: Options(contentType: Headers.jsonContentType),
      );
    }
  }

  bool _shouldRetryAsUpdate(final int? statusCode) => statusCode == 400 || statusCode == 409;
}
