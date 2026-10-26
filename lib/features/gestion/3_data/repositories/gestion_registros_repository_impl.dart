import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/authorization_envelope.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_registros_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/document_type.dart';

final class GestionRegistrosRepositoryImpl implements GestionRegistrosRepository {
  GestionRegistrosRepositoryImpl({required final Dio dio}) : _api = PublicacionApi(withGeneratedApiCompat(dio), standardSerializers);

  final PublicacionApi _api;

  /// TEMPORAL: en UAT el listado de registros tarda más que el timeout general
  /// de 20s (incidencia reportada a backend el 04/09/2026); se amplía a 5 min
  /// solo aquí. Retirar cuando backend responda dentro del plazo general.
  static const _registrosTimeout = Duration(minutes: 5);

  @override
  Future<List<Registro>> loadEntradas({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    return _loadRegistros(
      request: _request(documentNumber),
      fetch: (final request) => _api.myPubliSelecByNifTipoProcRegistrosEntradaOperation1(
        tipo: 'entrada',
        idAgente: citizenId,
        dtselectbynifv2reqBody: request,
        extra: {
          generatedApiTimeoutExtraKey: _registrosTimeout,
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
          generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
        },
      ),
    );
  }

  @override
  Future<List<Registro>> loadSalidas({
    required final String citizenId,
    required final String documentNumber,
  }) async {
    return _loadRegistros(
      request: _request(documentNumber),
      fetch: (final request) => _api.myPubliSelecByNifTipoProcRegistrosEntradaOperation1(
        tipo: 'salida',
        idAgente: citizenId,
        dtselectbynifv2reqBody: request,
        extra: {
          generatedApiTimeoutExtraKey: _registrosTimeout,
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
          generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
        },
      ),
    );
  }

  DTSELECTBYNIFV2REQ _request(final String documentNumber) {
    return DTSELECTBYNIFV2REQ(
      (final builder) => builder
        ..numerodocumento = documentNumber
        ..tipodocumento = documentTypeOf(documentNumber),
    );
  }

  Future<List<Registro>> _loadRegistros({
    required final DTSELECTBYNIFV2REQ request,
    required final Future<Response<dynamic>> Function(DTSELECTBYNIFV2REQ request) fetch,
  }) async {
    try {
      final response = await fetch(request);
      final raw = response.extra[generatedApiRawResponseDataExtraKey];
      _throwIfAuthorizationRequired(raw, statusCode: response.statusCode);
      return _rawRegistros(raw);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      _throwIfAuthorizationRequired(rawData, statusCode: error.response?.statusCode);
      final parsed = _rawRegistros(rawData);
      // El esquema generado modela la respuesta como un `oneOf` ambiguo. Al
      // deserializar una lista vacía puede lanzar aunque el backend haya
      // respondido correctamente; si el payload es de registros, conservar el
      // resultado (incluso vacío) en vez de propagar ese error del cliente.
      if (_isRegistrosPayload(rawData)) {
        return parsed;
      }
      rethrow;
    }
  }

  /// Traduce el sobre de autorización de la fachada a una señal tipada.
  ///
  /// Llega con 403, pero también dentro de un 2xx (el gateway falla cerrado),
  /// así que se comprueba en los dos caminos y **antes** de sacar datos del
  /// cuerpo — que aquí, además, acepta cuerpos de error como lista.
  void _throwIfAuthorizationRequired(final Object? data, {final int? statusCode}) {
    if (isAuthorizationRequiredEnvelope(data)) {
      logger.w('[registros] sobre de autorización (HTTP ${statusCode ?? 200})');
      throw AuthorizationRequiredException(statusCode: statusCode, path: 'registros');
    }
  }

  List<Registro> _rawRegistros(final Object? data) {
    final payload = _decode(data);
    final payloadMap = _asMap(payload);
    final root = _asMap(payloadMap?['body']) ?? payloadMap;
    if (root == null) {
      return const [];
    }

    final portalNode = _asMap(root['publicacionportal']);
    final itemsNode = portalNode?['item'];

    final items = switch (itemsNode) {
      final List<dynamic> list => list,
      final Map<dynamic, dynamic> single => [single],
      _ => const <dynamic>[],
    };

    return items.map(_asMap).whereType<Map<String, Object?>>().map(_toRegistroMap).where((final r) => r.numregistro.isNotEmpty).toList(growable: false);
  }

  bool _isRegistrosPayload(final Object? data) {
    final payload = _decode(data);
    final map = _asMap(payload);
    final root = _asMap(map?['body']) ?? map;
    return _asMap(root?['publicacionportal']) != null;
  }

  Registro _toRegistroMap(final Map<String, Object?> data) {
    return Registro(
      numregistro: _string(data, 'registro') ?? '',
      titulo: _string(data, 'desasunto') ?? _string(data, 'asuntoResumen') ?? _string(data, 'resumenAsunto') ?? '',
      fecha: _string(data, 'fechareg'),
      consejeria: _string(data, 'desconsej'),
    );
  }

  Object? _decode(final Object? raw) {
    Object? current = raw;
    for (var i = 0; i < 3; i++) {
      if (current is! String) {
        return current;
      }
      final trimmed = current.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      try {
        current = jsonDecode(trimmed);
      } on FormatException {
        return trimmed;
      }
    }
    return current;
  }

  Map<String, Object?>? _asMap(final Object? value) {
    if (value is Map<String, Object?>) {
      return value;
    }
    if (value is Map<dynamic, dynamic>) {
      return {
        for (final entry in value.entries)
          if (entry.key != null) entry.key.toString(): entry.value,
      };
    }
    return null;
  }

  String? _string(final Map<String, Object?> map, final String key) {
    final value = map[key];
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }
}
