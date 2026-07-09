import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente_aportacion_datos.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';

final class GestionExpedienteRepositoryImpl implements GestionExpedienteRepository {
  GestionExpedienteRepositoryImpl({required final Dio dio}) : _api = PublicacionApi(withGeneratedApiCompat(dio), standardSerializers);

  final PublicacionApi _api;

  @override
  Future<List<Expediente>> loadExpedientes({required final String documentNumber}) async {
    try {
      final response = await _api.myPubliSelecByNifOperation(
        dtselectbynifreqBody: DTSELECTBYNIFREQ(
          (final builder) => builder
            ..numerodocumento = documentNumber
            ..tipodoc = 'NIF',
        ),
        extra: {
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
          generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
        },
      );

      return _rawExpedientesByNif(response.extra[generatedApiRawResponseDataExtraKey]);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      final parsed = _rawExpedientesByNif(rawData);
      if (parsed.isNotEmpty) {
        return parsed;
      }
      rethrow;
    }
  }

  @override
  Future<Expediente> loadExpedienteDetail({
    required final String documentNumber,
    required final String numexp,
  }) async {
    final response = await _api.myPubliSelecByNumExpOperation(
      zcsrfcpubliselectbynumexpBody: ZCSRFCPUBLISELECTBYNUMEXP(
        (final builder) => builder
          ..pnumdoc = documentNumber
          ..pnumexp = numexp
          ..ptipodoc = 'NIF',
      ),
      extra: {
        generatedApiDecodeStringResponseExtraKey: true,
        generatedApiUnwrapBodyExtraKey: true,
        // A diferencia de selectbynif, aquí `publicacionportal` es un objeto
        // plano (no `.item`), según el ejemplo del swagger
        // (fachada-sede-api-swagger.yaml:6299) — no se normalizan colecciones
        // singleton.
      },
    );

    final expediente = _rawExpedienteDetail(response.extra[generatedApiRawResponseDataExtraKey]);
    if (expediente == null) {
      throw StateError('Respuesta de expediente sin datos.');
    }
    return expediente;
  }

  Expediente? _rawExpedienteDetail(final Object? data) {
    final payload = _decode(data);
    final payloadMap = _asMap(payload);
    final root = _asMap(payloadMap?['body']) ?? payloadMap;
    final portal = _asMap(root?['publicacionportal']);
    return portal == null ? null : _toExpedienteDetailMap(portal);
  }

  // Los nombres de campo del backend (estilo SAP) no se corresponden
  // literalmente con las etiquetas de Figma; se documenta la inferencia
  // porque no es obvia a partir de la clave sola.
  Expediente _toExpedienteDetailMap(final Map<String, Object?> data) {
    return Expediente(
      numexp: _string(data, 'numexp') ?? '',
      titulo: _string(data, 'titulo') ?? _string(data, 'descrip') ?? _string(data, 'desproc') ?? _string(data, 'asunto') ?? _string(data, 'desasunto') ?? '',
      consejeria: _string(data, 'desconsej') ?? _string(data, 'consej') ?? '',
      // "Oficina tramitadora": mejor candidato disponible es `desuniorg`
      // (descripción de la unidad orgánica, campo paralelo a `desconsej`).
      oficinaTramitadora: _string(data, 'desuniorg'),
      fechaInicio: _string(data, 'fechareg') ?? _string(data, 'fechaini'),
      // "0000-00-00" es el sentinel SAP de fecha nula; se trata como ausente.
      fechaFin: _nonSentinelDate(_string(data, 'fechafin')),
      estado: _string(data, 'descrip') ?? _string(data, 'estado'),
      tipoproc: _string(data, 'tipoproc'),
      // Campos en bruto necesarios para `inicproc`/`registrarfichero` al
      // aportar documentación — ver ExpedienteAportacionDatos.
      datosAportacion: ExpedienteAportacionDatos(
        uniorg: _string(data, 'uniorg'),
        consej: _string(data, 'consej'),
        bland: _string(data, 'bland'),
        asunto: _string(data, 'asunto'),
        desasunto: _string(data, 'desasunto'),
        source: _string(data, 'source'),
        nombre: _string(data, 'nombre'),
        apellido1: _string(data, 'apellido1'),
        apellido2: _string(data, 'apellido2'),
        numdoc: _string(data, 'numdoc'),
        codpos: _string(data, 'codpos'),
        calle: _string(data, 'calle'),
        ncalle: _string(data, 'ncalle'),
        tlfno: _string(data, 'tlfno'),
        bezei: _string(data, 'bezei'),
        registro: _string(data, 'registro'),
        fechareg: _string(data, 'fechareg'),
      ),
    );
  }

  String? _nonSentinelDate(final String? value) => (value == null || value == '0000-00-00') ? null : value;

  List<Expediente> _rawExpedientesByNif(final Object? data) {
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

    return items.map(_asMap).whereType<Map<String, Object?>>().map(_toExpedienteByNifMap).where((final e) => e.numexp.isNotEmpty).toList(growable: false);
  }

  Expediente _toExpedienteByNifMap(final Map<String, Object?> data) {
    return Expediente(
      numexp: _string(data, 'numexp') ?? '',
      titulo: _string(data, 'titulo') ?? _string(data, 'descrip') ?? _string(data, 'desproc') ?? _string(data, 'asunto') ?? _string(data, 'desasunto') ?? '',
      consejeria: _string(data, 'desconsej') ?? _string(data, 'consej') ?? '',
      fechaInicio: _string(data, 'fechareg') ?? _string(data, 'fechaini'),
      estado: _string(data, 'estado'),
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
