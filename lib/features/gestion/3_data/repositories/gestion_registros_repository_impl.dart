import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/registro.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/1_domain/repositories/gestion_registros_repository.dart';

final class GestionRegistrosRepositoryImpl implements GestionRegistrosRepository {
  GestionRegistrosRepositoryImpl({required final Dio dio}) : _api = PublicacionApi(withGeneratedApiCompat(dio), standardSerializers);

  final PublicacionApi _api;

  @override
  Future<List<Registro>> loadEntradas({required final String documentNumber}) async {
    return _loadRegistros(
      request: DTSELECTBYNIFV2REQ((final builder) => builder.numerodocumento = documentNumber),
      fetch: (final request, final validateStatus) => _api.myPubliSelecByNifTipoProcOperation2(
        dTSELECTBYNIFV2REQ: request,
        extra: {
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
        },
        validateStatus: validateStatus,
      ),
    );
  }

  @override
  Future<List<Registro>> loadSalidas({required final String documentNumber}) async {
    return _loadRegistros(
      request: DTSELECTBYNIFV2REQ((final builder) => builder.numerodocumento = documentNumber),
      fetch: (final request, final validateStatus) => _api.myPubliSelecByNifTipoProcOperation(
        dTSELECTBYNIFV2REQ: request,
        extra: {
          generatedApiDecodeStringResponseExtraKey: true,
          generatedApiNormalizeSingletonCollectionsExtraKey: const ['publicacionportal.item'],
        },
        validateStatus: validateStatus,
      ),
    );
  }

  Future<List<Registro>> _loadRegistros({
    required final DTSELECTBYNIFV2REQ request,
    required final Future<Response<ZCSRFCPUBLISELECTBYNIFResponse>> Function(DTSELECTBYNIFV2REQ request, ValidateStatus validateStatus) fetch,
  }) async {
    try {
      final response = await fetch(
        request,
        (final status) => status != null && status < 500,
      );

      if (response.statusCode == 404) {
        return const [];
      }

      final items = response.data?.publicacionportal?.item;
      if (items != null) {
        return items.map(_toRegistroDto).where((final r) => r.numregistro.isNotEmpty).toList(growable: false);
      }

      return _rawRegistros(response.extra[generatedApiRawResponseDataExtraKey]);
    } on DioException catch (error) {
      if (error.response?.statusCode == 404) {
        return const [];
      }
      final rawData = error.response?.data ?? error.response?.extra[generatedApiRawResponseDataExtraKey];
      final parsed = _rawRegistros(rawData);
      if (parsed.isNotEmpty) {
        return parsed;
      }
      rethrow;
    }
  }

  Registro _toRegistroDto(final ZCSSTPUBPORTAL data) {
    return Registro(
      numregistro: _emptyToNull(data.registro) ?? '',
      titulo: _emptyToNull(data.asunto) ?? _emptyToNull(data.titulo) ?? _emptyToNull(data.desasunto) ?? _emptyToNull(data.descrip) ?? '',
      fecha: _emptyToNull(data.fechareg),
      consejeria: _emptyToNull(data.desconsej),
    );
  }

  List<Registro> _rawRegistros(final Object? data) {
    final payload = _decode(data);
    final root = _asMap(payload);
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

  Registro _toRegistroMap(final Map<String, Object?> data) {
    return Registro(
      numregistro: _string(data, 'registro') ?? '',
      titulo: _string(data, 'asunto') ?? _string(data, 'titulo') ?? _string(data, 'desasunto') ?? _string(data, 'descrip') ?? '',
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

  String? _emptyToNull(final String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
