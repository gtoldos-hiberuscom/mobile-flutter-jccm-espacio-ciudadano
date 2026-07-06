import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/1_domain/repositories/digital_cards_repository.dart';

final class DigitalCardsRepositoryImpl implements DigitalCardsRepository {
  const DigitalCardsRepositoryImpl({required final Dio dio}) : _dio = dio;

  final Dio _dio;

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
      '/api/v1/carnet-digital/pdf/${Uri.encodeComponent(documentNumber)}',
      keys: const ['pdf', 'documento', 'datos', 'body'],
    );
  }

  @override
  Future<void> downloadPkPass({required final String documentNumber}) async {
    await _fetchRequiredArtifact(
      '/api/v1/carnet-digital/pkpass/${Uri.encodeComponent(documentNumber)}',
      keys: const ['pkpass', 'passpk', 'datos', 'body'],
    );
  }

  @override
  Future<void> downloadQr({required final String documentNumber}) async {
    await _fetchRequiredArtifact(
      '/api/v1/carnet-digital/qr/${Uri.encodeComponent(documentNumber)}',
      keys: const ['qr', 'datos', 'body'],
    );
  }

  @override
  Future<Uint8List?> loadQrImage({required final String documentNumber}) async {
    final payload = await _fetchOptionalArtifact(
      '/api/v1/carnet-digital/qr/${Uri.encodeComponent(documentNumber)}',
      keys: const ['qr', 'datos', 'body'],
    );
    if (payload == null) {
      return null;
    }
    return _decodeBase64Bytes(payload);
  }

  Future<DigitalCard?> _loadLargeFamilyCard(final String documentNumber) async {
    final response = await _getOptional('/api/v1/carnet-digital/familia-numerosa/${Uri.encodeComponent(documentNumber)}');
    if (response == null) {
      return null;
    }

    final payload = _decodePayload(response.data);
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
    final response = await _getOptional('/api/v1/carnet-digital/joven/${Uri.encodeComponent(documentNumber)}');
    if (response == null) {
      return null;
    }

    final payload = _decodePayload(response.data);
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

  Future<Response<Object?>?> _getOptional(final String path) async {
    final response = await _dio.get<Object?>(
      path,
      options: Options(
        validateStatus: (final status) => status != null && status < 500,
      ),
    );
    if (response.statusCode == 404) {
      return null;
    }
    if ((response.statusCode ?? 500) >= 400) {
      throw StateError('No se ha podido cargar el carnet.');
    }
    return response;
  }

  Future<String> _fetchRequiredArtifact(
    final String path, {
    required final List<String> keys,
  }) async {
    final payload = await _fetchOptionalArtifact(path, keys: keys);
    if (payload == null || payload.isEmpty) {
      throw StateError('La respuesta de descarga esta vacia.');
    }
    return payload;
  }

  Future<String?> _fetchOptionalArtifact(
    final String path, {
    required final List<String> keys,
  }) async {
    final response = await _dio.post<Object?>(
      path,
      options: Options(
        validateStatus: (final status) => status != null && status < 500,
      ),
    );
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
