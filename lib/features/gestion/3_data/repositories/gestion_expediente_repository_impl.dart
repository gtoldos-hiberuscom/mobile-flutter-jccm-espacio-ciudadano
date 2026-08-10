import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente_aportacion_datos.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_expediente_repository.dart';

final class GestionExpedienteRepositoryImpl implements GestionExpedienteRepository {
  GestionExpedienteRepositoryImpl({required final Dio dio}) : _api = PublicacionApi(withGeneratedApiCompat(dio), standardSerializers);

  final PublicacionApi _api;

  @override
  Future<List<Expediente>> loadExpedientes({required final String documentNumber}) async {
    logger.d('[selectbynifexp] req numerodocumento=$documentNumber tipodocumento=NIF');
    try {
      final response = await _api.myPubliSelecByNifTipoProcExpOperation(
        dtselectbynifv2reqBody: DTSELECTBYNIFV2REQ(
          (final builder) => builder
            ..numerodocumento = documentNumber
            ..tipodocumento = 'NIF',
        ),
        extra: {
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiUnwrapBodyExtraKey: true,
          generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
        },
      );

      final raw = response.extra[generatedApiRawResponseDataExtraKey];
      _logEnvelope('selectbynifexp', raw);
      final expedientes = _rawExpedientesByNif(raw);
      logger.d('[selectbynifexp] ok ${expedientes.length} expediente(s)');
      return expedientes;
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        logger.w('[selectbynifexp] 404 → lista vacía');
        return const [];
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      _logEnvelope('selectbynifexp(error)', rawData);
      final parsed = _rawExpedientesByNif(rawData);
      if (parsed.isNotEmpty) {
        logger.w('[selectbynifexp] error HTTP pero cuerpo con ${parsed.length} expediente(s) → se usa el cuerpo');
        return parsed;
      }
      logger.e('[selectbynifexp] error sin cuerpo aprovechable', error: error);
      rethrow;
    }
  }

  @override
  Future<Expediente> loadExpedienteDetail({
    required final String documentNumber,
    required final String numexp,
    final String tipodoc = 'NIF',
  }) async {
    logger.d('[selectbynumexp] req pnumdoc=$documentNumber pnumexp=$numexp ptipodoc=NIF (tipodoc recibido=$tipodoc)');
    final response = await _api.myPubliSelecByNumExpOperation(
      zcsrfcpubliselectbynumexpBody: ZCSRFCPUBLISELECTBYNUMEXP(
        (final builder) => builder
          ..pnumdoc = documentNumber
          ..pnumexp = numexp
          ..ptipodoc = 'NIF',
        // ..ptipodoc = tipodoc,
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

    final raw = response.extra[generatedApiRawResponseDataExtraKey];
    _logEnvelope('selectbynumexp', raw);
    final expediente = _rawExpedienteDetail(raw);
    if (expediente == null) {
      logger.w('[selectbynumexp] sin datos para pnumexp=$numexp (200 pero publicacionportal vacío/nulo)');
      throw StateError('Respuesta de expediente sin datos.');
    }
    logger.d('[selectbynumexp] ok numexp=${expediente.numexp}');
    return expediente;
  }

  @override
  Future<Expediente> loadExpedienteByRegistro({
    required final String documentNumber,
    required final String numRegistro,
    final String tipodoc = 'NIF',
  }) async {
    logger.d('[selectbynumreg] req pnumdoc=$documentNumber pregistro=$numRegistro ptipodoc=NIF (tipodoc recibido=$tipodoc)');
    final response = await _api.myPubliNumRegOperation(
      zcsrfcpubliselectbynumregBody: ZCSRFCPUBLISELECTBYNUMREG(
        (final builder) => builder
          ..pnumdoc = documentNumber
          ..pregistro = numRegistro
          // El backend rechaza ptipodoc='DNI' con 403; igual que
          // selectbynumexp, siempre debe enviarse 'NIF'.
          ..ptipodoc = 'NIF',
      ),
      extra: {
        generatedApiDecodeStringResponseExtraKey: true,
        generatedApiUnwrapBodyExtraKey: true,
        // A diferencia de selectbynumexp, aquí `publicacionportal.item` es
        // una lista (fachada-sede-api-swagger.yaml, ejemplo de
        // selectbynumreg) aunque solo pueda haber un expediente por número
        // de registro — se normaliza para tratarla igual que selectbynif.
        generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
      },
    );

    final raw = response.extra[generatedApiRawResponseDataExtraKey];
    _logEnvelope('selectbynumreg', raw);
    final expediente = _rawExpedienteByRegistro(raw);
    if (expediente == null) {
      logger.w('[selectbynumreg] sin datos para pregistro=$numRegistro (200 pero publicacionportal.item vacío/nulo)');
      throw StateError('Respuesta de expediente sin datos.');
    }
    logger.d('[selectbynumreg] ok numexp=${expediente.numexp}');
    return expediente;
  }

  /// Registra los campos de diagnóstico del sobre de respuesta del backend.
  /// Este backend puede responder `200 OK` con `isubrc: 1` +
  /// `resultado: "No hay publicaciones..."` y un `publicacionportal` con todos
  /// los campos a `null` cuando no encuentra nada — no un 404. Esta traza
  /// hace visible ese caso durante la depuración.
  void _logEnvelope(final String op, final Object? raw) {
    final payload = _asMap(_decode(raw));
    final body = _asMap(payload?['body']) ?? payload;
    logger.d(
      '[$op] envelope codigo-respuesta=${payload?['codigo-respuesta']} '
      'mensaje=${payload?['mensaje-respuesta']} isubrc=${body?['isubrc']} '
      'resultado=${body?['resultado']}',
    );
  }

  Expediente? _rawExpedienteByRegistro(final Object? data) {
    final payload = _decode(data);
    final payloadMap = _asMap(payload);
    final root = _asMap(payloadMap?['body']) ?? payloadMap;
    final portalNode = _asMap(root?['publicacionportal']);
    final itemsNode = portalNode?['item'];

    final items = switch (itemsNode) {
      final List<dynamic> list => list,
      final Map<dynamic, dynamic> single => [single],
      _ => const <dynamic>[],
    };

    final first = items.map(_asMap).whereType<Map<String, Object?>>().firstOrNull;
    return first == null ? null : _toExpedienteDetailMap(first, canAttachDocuments: _canAttachDocuments(root));
  }

  Expediente? _rawExpedienteDetail(final Object? data) {
    final payload = _decode(data);
    final payloadMap = _asMap(payload);
    final root = _asMap(payloadMap?['body']) ?? payloadMap;
    final portal = _asMap(root?['publicacionportal']);
    if (portal == null) {
      return null;
    }
    final expediente = _toExpedienteDetailMap(portal, canAttachDocuments: _canAttachDocuments(root));
    // El backend devuelve 200 con `publicacionportal` presente pero con todos
    // los campos a `null` (isubrc:1, "No hay publicaciones...") cuando no
    // encuentra el expediente. Sin este guard se mapearía un `Expediente` con
    // `numexp` vacío en vez de tratarse como "no encontrado" — mismo criterio
    // que `_rawExpedientesByNif`, que filtra los `numexp` vacíos.
    return expediente.numexp.isEmpty ? null : expediente;
  }

  // Los nombres de campo del backend (estilo SAP) no se corresponden
  // literalmente con las etiquetas de Figma; se documenta la inferencia
  // porque no es obvia a partir de la clave sola.
  Expediente _toExpedienteDetailMap(final Map<String, Object?> data, {required final bool canAttachDocuments}) {
    return Expediente(
      numexp: _string(data, 'numexp') ?? '',
      titulo: _string(data, 'titulo') ?? _string(data, 'desproc') ?? _string(data, 'asunto') ?? _string(data, 'desasunto') ?? '',
      consejeria: _string(data, 'desconsej') ?? _string(data, 'consej') ?? '',
      // "Oficina tramitadora": mejor candidato disponible es `desuniorg`
      // (descripción de la unidad orgánica, campo paralelo a `desconsej`).
      oficinaTramitadora: _string(data, 'desuniorg'),
      fechaInicio: _string(data, 'fechareg') ?? _string(data, 'fechaini'),
      // "0000-00-00" es el sentinel SAP de fecha nula; se trata como ausente.
      fechaFin: _nonSentinelDate(_string(data, 'fechafin')),
      estado: _estadoDescripcion(data),
      tipoproc: _string(data, 'tipoproc'),
      canAttachDocuments: canAttachDocuments,
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

  bool _canAttachDocuments(final Map<String, Object?>? responseBody) => responseBody != null && _string(responseBody, 'adjuntar') == 'X';

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
      titulo: _string(data, 'titulo') ?? _string(data, 'desproc') ?? _string(data, 'asunto') ?? _string(data, 'desasunto') ?? '',
      consejeria: _string(data, 'desconsej') ?? _string(data, 'consej') ?? '',
      fechaInicio: _string(data, 'fechareg') ?? _string(data, 'fechaini'),
      estado: _estadoDescripcion(data),
    );
  }

  String? _estadoDescripcion(final Map<String, Object?> data) {
    final description = _string(data, 'descrip') ?? _string(data, 'desestado') ?? _string(data, 'descestado') ?? _string(data, 'estadoDescripcion');
    if (description != null) {
      return description;
    }

    final estado = _string(data, 'estado');
    return estado != null && !RegExp(r'^\d+$').hasMatch(estado) ? estado : null;
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
