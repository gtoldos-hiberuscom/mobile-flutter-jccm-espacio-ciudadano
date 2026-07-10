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
  final Map<String, _RemoteClauses> _remoteClausesCache = {};
  final Map<String, Future<_RemoteClauses?>> _remoteClausesRequests = {};

  // ── Fallback clause catalogue ─────────────────────────────────────────────
  //
  // Labels are legal text validated by the JCCM legal team. Version '1.0'
  // is the initial release. Update the version string to force re-consent
  // when the text changes.
  static const _fallbackClauses = [
    Clause(
      id: 0,
      label:
          'He leído y acepto la información de protección de datos sobre el '
          'tratamiento de datos personales.',
      isSelected: false,
    ),
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
          'Autorizo la consulta de los datos que la Administración General del '
          'Estado tiene sobre mí para que se muestren en Espacio Ciudadano.',
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
  }) async {
    final normalizedId = idAgente.trim();
    if (normalizedId.isEmpty) {
      return false;
    }

    final remote = await _fetchRemoteClauses(normalizedId);
    if (remote != null) {
      final hasCompletedConsent = _hasCompletedConsent(remote);
      await _cacheClauses(idAgente: normalizedId, clauses: remote.clauses);
      await _storage.write(_key(normalizedId), hasCompletedConsent);
      return hasCompletedConsent;
    }

    return _storage.read<bool>(_key(normalizedId)) ?? false;
  }

  @override
  Future<void> markConsentAccepted({
    required final String idAgente,
    required final List<Clause> clauses,
  }) async {
    final normalizedId = idAgente.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(idAgente, 'idAgente', 'No puede estar vacío.');
    }

    final hasExistingRemoteClauses = _remoteClausesCache.containsKey(normalizedId) || await _fetchRemoteClauses(normalizedId) != null;
    final requestBody = _requestBody(normalizedId, clauses);

    try {
      await _syncClauses(requestBody, updateExisting: hasExistingRemoteClauses);
    } catch (e, stackTrace) {
      logger.e('Failed to sync clausulas with API: $e', stackTrace: stackTrace);
      rethrow;
    }

    await _cacheClauses(idAgente: normalizedId, clauses: clauses);
    _remoteClausesCache[normalizedId] = _RemoteClauses(
      clauses: clauses,
      hasPending: false,
    );
    await _storage.write(_key(normalizedId), true);
  }

  @override
  Future<void> resetConsentClauses({
    required final String idAgente,
  }) async {
    final normalizedId = idAgente.trim();
    if (normalizedId.isEmpty) {
      throw ArgumentError.value(idAgente, 'idAgente', 'No puede estar vacío.');
    }

    final remote = await _fetchRemoteClauses(normalizedId);
    if (remote == null) {
      _remoteClausesCache.remove(normalizedId);
      await _clearLocalConsent(normalizedId);
      return;
    }

    final resetClauses = remote.clauses.map((final clause) => clause.copyWith(isSelected: false)).toList(growable: false);
    try {
      await _dio.patch<Map<String, dynamic>>(
        '/api/v1/hechos-vitales/clausulas',
        data: _requestBody(normalizedId, resetClauses),
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode != 404) {
        logger.e('Failed to reset clausulas with API: $error', stackTrace: stackTrace);
        rethrow;
      }
    }

    _remoteClausesCache.remove(normalizedId);
    await _clearLocalConsent(normalizedId);
  }

  @override
  Future<bool> hasAcceptedClause({
    required final String idAgente,
    required final int clauseId,
  }) async {
    final normalizedId = idAgente.trim();
    if (normalizedId.isEmpty) {
      return false;
    }

    final remote = await _fetchRemoteClauses(normalizedId);
    if (remote != null) {
      await _cacheClauses(idAgente: normalizedId, clauses: remote.clauses);
      return remote.clauses.any((final clause) => clause.id == clauseId && clause.isSelected);
    }

    final acceptedClauseIds = _storage.read<List<String>>(_acceptedClausesKey(normalizedId)) ?? const [];
    return acceptedClauseIds.contains(clauseId.toString());
  }

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) async {
    final normalizedId = idAgente?.trim();
    if (normalizedId != null && normalizedId.isNotEmpty) {
      final remote = await _fetchRemoteClauses(normalizedId);
      if (remote != null) {
        await _cacheClauses(idAgente: normalizedId, clauses: remote.clauses);
        await _storage.write(_key(normalizedId), _hasCompletedConsent(remote));
        return remote.clauses;
      }

      final acceptedClauseIds = _storage.read<List<String>>(_acceptedClausesKey(normalizedId)) ?? const [];
      return _fallbackClauses.map((final clause) => clause.copyWith(isSelected: acceptedClauseIds.contains(clause.id.toString()))).toList(growable: false);
    }

    return _fallbackClauses;
  }

  // ── Private ───────────────────────────────────────────────────────────────

  String _key(final String idAgente) => '${StorageKeys.consentAcceptedPrefix}$idAgente';

  String _acceptedClausesKey(final String idAgente) => '${StorageKeys.consentAcceptedClausesPrefix}$idAgente';

  Map<String, dynamic> _requestBody(final String idAgente, final List<Clause> clauses) {
    return <String, dynamic>{
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
  }

  Future<void> _cacheClauses({
    required final String idAgente,
    required final List<Clause> clauses,
  }) async {
    final acceptedClauseIds = clauses.where((final clause) => clause.isSelected).map((final clause) => clause.id.toString()).toList(growable: false);
    await _storage.write(_acceptedClausesKey(idAgente), acceptedClauseIds);
  }

  Future<void> _clearLocalConsent(final String idAgente) async {
    await Future.wait([
      _storage.remove(_key(idAgente)),
      _storage.remove(_acceptedClausesKey(idAgente)),
    ]);
  }

  bool _hasCompletedConsent(final _RemoteClauses remote) {
    final hasAcceptedRequiredClause = remote.clauses.any((final clause) => clause.id == 0 && clause.isSelected);
    return !remote.hasPending && hasAcceptedRequiredClause;
  }

  Future<_RemoteClauses?> _fetchRemoteClauses(final String idAgente) async {
    if (idAgente.trim().isEmpty) {
      return null;
    }
    final cached = _remoteClausesCache[idAgente];
    if (cached != null) {
      return cached;
    }
    final inFlight = _remoteClausesRequests[idAgente];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchRemoteClausesUncached(idAgente);
    _remoteClausesRequests[idAgente] = request;
    try {
      final remote = await request;
      if (remote != null) {
        _remoteClausesCache[idAgente] = remote;
      }
      return remote;
    } finally {
      final _ = _remoteClausesRequests.remove(idAgente);
    }
  }

  Future<_RemoteClauses?> _fetchRemoteClausesUncached(final String idAgente) async {
    try {
      final response = await _dio.get<Object?>(
        '/api/v1/hechos-vitales/clausulas/${Uri.encodeComponent(idAgente)}',
      );
      final data = response.data;
      if (data is! Map) {
        return null;
      }
      final body = _asMap(data['body']);
      if (body == null) {
        return null;
      }
      final clausesPayload = body['textosClausulas'];
      if (clausesPayload is! List) {
        return null;
      }
      final clauses = clausesPayload.map(_clauseFromRemote).nonNulls.toList(growable: false);
      if (clauses.isEmpty) {
        return null;
      }
      return _RemoteClauses(
        clauses: clauses,
        hasPending: _asBool(body['clausulaPendiente']) ?? false,
      );
    } on DioException catch (error, stackTrace) {
      if (error.response?.statusCode == 404) {
        return null;
      }
      logger.e('Failed to fetch remote clausulas: $error', stackTrace: stackTrace);
      return null;
    }
  }

  Clause? _clauseFromRemote(final Object? value) {
    final map = _asMap(value);
    if (map == null) {
      return null;
    }
    final id = _asInt(map['idClausula']);
    if (id == null) {
      return null;
    }
    return Clause(
      id: id,
      label: _htmlToText(map['textoCheck']?.toString() ?? map['descripcion']?.toString() ?? 'Cláusula $id'),
      isSelected: _asBool(map['seleccionado']) ?? false,
      version: map['version']?.toString() ?? '1',
    );
  }

  Map<String, Object?>? _asMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map) {
      return {
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  int? _asInt(final Object? value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString().trim() ?? '');
  }

  bool? _asBool(final Object? value) {
    if (value is bool) {
      return value;
    }
    return switch (value?.toString().trim().toLowerCase()) {
      'true' || 's' || 'si' || 'sí' || '1' => true,
      'false' || 'n' || 'no' || '0' => false,
      _ => null,
    };
  }

  String _htmlToText(final String value) {
    return value.replaceAll(RegExp('<[^>]+>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  Future<void> _syncClauses(
    final Map<String, dynamic> requestBody, {
    required final bool updateExisting,
  }) async {
    if (updateExisting) {
      try {
        await _dio.patch<Map<String, dynamic>>(
          '/api/v1/hechos-vitales/clausulas',
          data: requestBody,
          options: Options(contentType: Headers.jsonContentType),
        );
      } on DioException catch (error) {
        if (error.response?.statusCode != 404) {
          rethrow;
        }
        await _dio.post<Map<String, dynamic>>(
          '/api/v1/hechos-vitales/clausulas',
          data: requestBody,
          options: Options(contentType: Headers.jsonContentType),
        );
      }
      return;
    }

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

final class _RemoteClauses {
  const _RemoteClauses({
    required this.clauses,
    required this.hasPending,
  });

  final List<Clause> clauses;
  final bool hasPending;
}
