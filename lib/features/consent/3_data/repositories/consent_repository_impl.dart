import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/core/storage/storage_keys.dart';
import 'package:jccm_espacio_ciudadano/features/consent/0_entity/clause.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_status_unknown_exception.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/api/clausulas_api.dart';

/// Hybrid implementation of [ConsentRepository] using both API and local storage.
///
/// Consent acceptance is persisted per citizen through the citizen-resource
/// clausulas endpoints. Local storage (SharedPreferences) is used as cache and
/// fallback.
final class ConsentRepositoryImpl implements ConsentRepository {
  ConsentRepositoryImpl({
    required final AppStorage storage,
    required final Dio dio,
    final String? agentId,
  }) : _storage = storage,
       _agentId = agentId?.trim(),
       _api = ClausulasApi(dio);

  final AppStorage _storage;
  final String? _agentId;
  final ClausulasApi _api;
  final Map<String, _RemoteClauses> _remoteClausesCache = {};
  final Map<String, Future<_RemoteClauses?>> _remoteClausesRequests = {};

  // ── ConsentRepository ──────────────────────────────────────────────────────

  @override
  Future<bool> hasAcceptedConsent({
    required final String idAgente,
  }) async {
    final normalizedId = idAgente.trim();
    if (normalizedId.isEmpty) {
      return false;
    }

    final _RemoteClauses? remote;
    try {
      remote = await _fetchRemoteClauses(normalizedId);
    } on ConsentStatusUnknownException {
      // Positive-only local fallback: the cached flag is written `true` solely
      // after a confirmed remote answer or a successful accept, so it is
      // trustworthy evidence. A cached `false` (or nothing) proves nothing —
      // propagate UNKNOWN instead of reporting "not accepted".
      if (_storage.read<bool>(_key(normalizedId)) ?? false) {
        return true;
      }
      rethrow;
    }
    if (remote == null) {
      // Genuine 404 — consent really is not registered for this citizen.
      return false;
    }

    final hasCompletedConsent = _hasCompletedConsent(remote);
    await _cacheClauses(idAgente: normalizedId, clauses: remote.clauses);
    await _storage.write(_key(normalizedId), hasCompletedConsent);
    return hasCompletedConsent;
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

    bool hasExistingRemoteClauses = _remoteClausesCache.containsKey(normalizedId);
    if (!hasExistingRemoteClauses) {
      try {
        hasExistingRemoteClauses = await _fetchRemoteClauses(normalizedId) != null;
      } on ConsentStatusUnknownException {
        // The probe only chooses the initial verb; _syncClauses self-heals a
        // wrong guess (404 → POST, 400/409 → PATCH), so an unavailable GET
        // must not abort the write.
        hasExistingRemoteClauses = false;
      }
    }
    final requestBody = _requestBody(_requestAgentId(normalizedId), clauses);

    try {
      await _syncClauses(
        citizenId: normalizedId,
        requestBody: requestBody,
        updateExisting: hasExistingRemoteClauses,
      );
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
      await _api.actualizar(
        citizenId: normalizedId,
        body: _requestBody(_requestAgentId(normalizedId), resetClauses),
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

    final _RemoteClauses? remote;
    try {
      remote = await _fetchRemoteClauses(normalizedId);
    } on ConsentStatusUnknownException {
      // Positive-only fallback, mirroring [hasAcceptedConsent]: an id present
      // in the cached accepted list was confirmed remotely at some point; its
      // absence proves nothing while the backend cannot answer.
      final acceptedClauseIds = _storage.read<List<String>>(_acceptedClausesKey(normalizedId)) ?? const [];
      if (acceptedClauseIds.contains(clauseId.toString())) {
        return true;
      }
      rethrow;
    }
    if (remote == null) {
      return false;
    }

    await _cacheClauses(idAgente: normalizedId, clauses: remote.clauses);
    return remote.clauses.any((final clause) => clause.id == clauseId && clause.isSelected);
  }

  @override
  Future<List<Clause>> fetchClauses({final String? idAgente}) async {
    final normalizedId = idAgente?.trim();
    if (normalizedId == null || normalizedId.isEmpty) {
      throw StateError('An agent id is required to fetch consent clauses');
    }

    final remote = await _fetchRemoteClauses(normalizedId);
    if (remote == null) {
      throw StateError('Consent clauses were not returned by the API');
    }

    await _cacheClauses(idAgente: normalizedId, clauses: remote.clauses);
    await _storage.write(_key(normalizedId), _hasCompletedConsent(remote));
    return remote.clauses;
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

  String _requestAgentId(final String citizenId) {
    final agentId = _agentId;
    return agentId == null || agentId.isEmpty ? citizenId : agentId;
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
    final hasAcceptedRequiredClause = remote.clauses.any((final clause) => clause.id == requiredConsentClauseId && clause.isSelected);
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
      return _remoteClausesFromData(await _api.obtener(citizenId: idAgente));
    } on DioException catch (error, stackTrace) {
      final statusCode = error.response?.statusCode;
      // 404 is the only failure that carries meaning: the citizen genuinely
      // has no clauses registered yet. Anything else leaves the status UNKNOWN.
      if (statusCode == 404) {
        return null;
      }
      final remote = _remoteClausesFromData(decodeApiEnvelope(error.response?.data));
      if (remote != null) {
        return remote;
      }
      logger.e('GET clausulas failed (status: $statusCode, type: ${error.type}): $error', stackTrace: stackTrace);
      throw ConsentStatusUnknownException(
        message: 'Clausulas endpoint unavailable',
        statusCode: statusCode,
        cause: error,
      );
    }
  }

  _RemoteClauses? _remoteClausesFromData(final Object? data) {
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
      label: _htmlToText(map['textoCheck']?.toString() ?? ''),
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

  Future<void> _syncClauses({
    required final String citizenId,
    required final Map<String, dynamic> requestBody,
    required final bool updateExisting,
  }) async {
    if (updateExisting) {
      try {
        await _api.actualizar(citizenId: citizenId, body: requestBody);
      } on DioException catch (error) {
        if (error.response?.statusCode != 404) {
          rethrow;
        }
        await _api.enviar(citizenId: citizenId, body: requestBody);
      }
      return;
    }

    try {
      await _api.enviar(citizenId: citizenId, body: requestBody);
    } on DioException catch (error) {
      if (!_shouldRetryAsUpdate(error.response?.statusCode)) {
        rethrow;
      }

      await _api.actualizar(citizenId: citizenId, body: requestBody);
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
