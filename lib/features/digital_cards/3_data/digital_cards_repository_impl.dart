import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/repositories/digital_cards_repository.dart';

final class DigitalCardsRepositoryImpl implements DigitalCardsRepository {
  DigitalCardsRepositoryImpl({required final Dio dio}) : _api = CarnetDigitalApi(withGeneratedApiCompat(dio), standardSerializers);

  final CarnetDigitalApi _api;

  @override
  Future<List<DigitalCard>> loadCards({required final String documentNumber}) async {
    final results = await Future.wait<Object?>([
      _loadLargeFamilyCard(documentNumber),
      _loadYouthCard(documentNumber),
    ]);

    return results.whereType<DigitalCard>().toList(growable: false);
  }

  @override
  Future<void> downloadPdf({required final String documentNumber}) async {
    await _fetchRequiredArtifact(
      () => _api.obtenerPdf(
        dni: documentNumber,
        extra: _generatedExtra,
        validateStatus: (final status) => status != null && status < 500,
      ),
      keys: const ['pdf', 'documento', 'datos', 'body'],
    );
  }

  @override
  Future<void> downloadPkPass({required final String documentNumber}) async {
    await _fetchRequiredArtifact(
      () => _api.obtenerPkPass(
        dni: documentNumber,
        extra: _generatedExtra,
        validateStatus: (final status) => status != null && status < 500,
      ),
      keys: const ['pkpass', 'passpk', 'datos', 'body'],
    );
  }

  @override
  Future<void> downloadQr({required final String documentNumber}) async {
    await _fetchRequiredArtifact(
      () => _api.obtenerQr(
        dni: documentNumber,
        extra: _generatedExtra,
        validateStatus: (final status) => status != null && status < 500,
      ),
      keys: const ['qr', 'datos', 'body'],
    );
  }

  @override
  Future<Uint8List?> loadQrImage({required final String documentNumber}) async {
    final payload = await _fetchOptionalArtifact(
      () => _api.obtenerQr(
        dni: documentNumber,
        extra: _generatedExtra,
        validateStatus: (final status) => status != null && status < 500,
      ),
      keys: const ['qr', 'datos', 'body'],
    );
    if (payload == null) {
      return null;
    }
    return _decodeBase64Bytes(payload);
  }

  Future<DigitalCard?> _loadLargeFamilyCard(final String documentNumber) async {
    final response = await _getOptional(
      () => _api.obtenerDatosFamiliaNumerosa(
        dni: documentNumber,
        extra: _generatedExtra,
        validateStatus: (final status) => status != null && status < 500,
      ),
    );
    if (response == null) {
      return null;
    }

    final payload = _decodePayload(response);
    final map = _firstMap(payload);
    if (map == null || _hasBusinessError(map)) {
      return null;
    }

    final dataMap = _payloadBody(map);
    final number = _firstString(dataMap, const ['numeroTitulo', 'NumeroTitulo', 'numero_titulo', 'numTitulo', 'titulo']);
    if (number == null || number.isEmpty) {
      return null;
    }

    return DigitalCard(
      type: DigitalCardType.largeFamily,
      title: 'Familia Numerosa',
      number: number,
      expiresAt: _parseDate(_firstString(dataMap, const ['fechaValidezHasta', 'fecha_validez_hasta', 'fechaCaducidad', 'fecha_caducidad'])),
    );
  }

  Future<DigitalCard?> _loadYouthCard(final String documentNumber) async {
    final response = await _getOptional(
      () => _api.obtenerCarnetJoven(
        dni: documentNumber,
        extra: _generatedExtra,
        validateStatus: (final status) => status != null && status < 500,
      ),
    );
    if (response == null) {
      return null;
    }

    final payload = _decodePayload(response);
    final map = _firstMap(payload);
    if (map == null || _hasBusinessError(map)) {
      return null;
    }

    final dataMap = _payloadBody(map);
    final number = _firstString(dataMap, const ['numero', 'Numero', 'numeroCarnet', 'NumeroCarnet', 'numero_carnet', 'codigo', 'Codigo', 'id']);
    if (number == null || number.isEmpty) {
      return null;
    }

    return DigitalCard(
      type: DigitalCardType.youth,
      title: 'Carné Internacional de Estudiante (ISIC)',
      number: number,
      expiresAt: _parseDate(_firstString(dataMap, const ['fechaFinValidez', 'FechaFinValidez', 'fecha_fin_validez', 'fechaCaducidad', 'FechaCaducidad', 'fecha_caducidad'])),
    );
  }

  Map<String, dynamic> get _generatedExtra => const {
    generatedApiDecodeStringResponseExtraKey: true,
  };

  Future<Object?> _getOptional(final Future<Response<Respuesta>> Function() fetch) async {
    final response = await _rawResponse(fetch);
    if (response.statusCode == 404) {
      return null;
    }
    if ((response.statusCode ?? 500) >= 400) {
      throw StateError('No se ha podido cargar el carnet.');
    }
    return response.data;
  }

  Future<String> _fetchRequiredArtifact(
    final Future<Response<Respuesta>> Function() fetch, {
    required final List<String> keys,
  }) async {
    final payload = await _fetchOptionalArtifact(fetch, keys: keys);
    if (payload == null || payload.isEmpty) {
      throw StateError('La respuesta de descarga esta vacia.');
    }
    return payload;
  }

  Future<String?> _fetchOptionalArtifact(
    final Future<Response<Respuesta>> Function() fetch, {
    required final List<String> keys,
  }) async {
    final response = await _rawResponse(fetch);
    if (response.statusCode == 404) {
      return null;
    }
    if ((response.statusCode ?? 500) >= 400) {
      throw StateError('No se ha podido descargar el carnet.');
    }

    final payload = _decodePayload(response.data);
    if (payload is String) {
      final text = payload.trim();
      return text.isEmpty ? null : text;
    }

    final map = _firstMap(payload);
    if (map == null || _hasBusinessError(map)) {
      return null;
    }
    final body = _payloadBody(map);
    return _firstString(body, keys) ?? _firstString(map, keys);
  }

  Future<({Object? data, int? statusCode})> _rawResponse(final Future<Response<Respuesta>> Function() fetch) async {
    try {
      final response = await fetch();
      return (
        data: response.extra[generatedApiRawResponseDataExtraKey] ?? response.data,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      final rawData = error.response?.extra[generatedApiRawResponseDataExtraKey] ?? error.response?.data;
      if (error.response != null || rawData != null) {
        return (data: rawData, statusCode: error.response?.statusCode);
      }
      rethrow;
    }
  }

  bool _hasBusinessError(final Map<String, Object?> map) {
    final code = _firstString(map, const ['codError', 'codigoError', 'errorCode', 'codigo-respuesta']);
    return code != null && code.isNotEmpty && code != '0' && code != '00' && !code.startsWith('200');
  }

  Map<String, Object?> _payloadBody(final Map<String, Object?> map) {
    return _firstMap(map['datos']) ?? _firstMap(map['body']) ?? map;
  }

  Object? _decodePayload(final Object? payload) {
    Object? current = payload;
    for (var i = 0; i < 4; i++) {
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
        return current;
      }
    }
    return current;
  }

  Map<String, Object?>? _firstMap(final Object? payload) {
    if (payload is Map) {
      return payload.map((final key, final value) => MapEntry(key.toString(), value));
    }
    if (payload is List) {
      for (final item in payload) {
        final map = _firstMap(item);
        if (map != null) {
          return map;
        }
      }
    }
    return null;
  }

  String? _firstString(final Map<String, Object?>? map, final List<String> keys) {
    if (map == null) {
      return null;
    }
    for (final key in keys) {
      final value = map[key];
      if (value == null) {
        continue;
      }
      final text = value.toString().trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return null;
  }

  DateTime? _parseDate(final String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final iso = DateTime.tryParse(value) ?? DateTime.tryParse(value.split('T').first);
    if (iso != null) {
      return iso;
    }

    final slashParts = value.split('/');
    if (slashParts.length == 3) {
      final day = int.tryParse(slashParts[0]);
      final month = int.tryParse(slashParts[1]);
      final year = int.tryParse(slashParts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }

  Uint8List? _decodeBase64Bytes(final String value) {
    var normalized = value.trim();
    final commaIndex = normalized.indexOf(',');
    if (normalized.startsWith('data:') && commaIndex != -1) {
      normalized = normalized.substring(commaIndex + 1);
    }
    normalized = normalized.replaceAll(RegExp(r'\s+'), '');
    try {
      return base64Decode(normalized);
    } on FormatException {
      return null;
    }
  }
}
