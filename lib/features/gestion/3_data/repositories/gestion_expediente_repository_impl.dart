import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente.dart';
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

      final items = response.data?.publicacionportal?.item;
      if (items != null) {
        return items.map(_toExpedienteByNifDto).where((final e) => e.numexp.isNotEmpty).toList(growable: false);
      }

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

  Expediente _toExpedienteByNifDto(final ZCSSTPUBPORTAL data) {
    return Expediente(
      numexp: _emptyToNull(data.numexp) ?? '',
      titulo: _emptyToNull(data.titulo) ?? _emptyToNull(data.descrip) ?? _emptyToNull(data.desproc) ?? _emptyToNull(data.asunto) ?? _emptyToNull(data.desasunto) ?? '',
      consejeria: _emptyToNull(data.desconsej) ?? _emptyToNull(data.consej) ?? '',
      fechaInicio: _emptyToNull(data.fechareg) ?? _emptyToNull(data.fechaini),
      estado: _emptyToNull(data.estado),
    );
  }

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

  String? _emptyToNull(final String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
