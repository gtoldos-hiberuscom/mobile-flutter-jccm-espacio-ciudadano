import 'package:built_collection/built_collection.dart';
import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/core/network/generated_api_compat.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';

const lifeEventsSupportUnavailableMessage = 'No se han podido guardar tus hechos vitales. Inténtalo de nuevo más tarde.';

final class LifeEventsSupportUnavailableException implements Exception {
  const LifeEventsSupportUnavailableException();

  @override
  String toString() => lifeEventsSupportUnavailableMessage;
}

/// Concrete implementation of [LifeEventsRepository] backed by Hechos Vitales.
///
/// Lives in `3_data/` — all API types are mapped to domain entities before
/// returning. No generated model, DTO, or Dio type escapes this class.
///
/// **Note on `loadLifeEvents`**: the GET endpoint wraps its payload in a
/// `Respuesta` envelope (`{ body: { idAgente, listaHechos: [...] }, ... }`)
/// even though the OpenAPI spec declares the return type as `ListaHechos`
/// directly. The generated client therefore deserialises to an empty object.
/// Raw Dio is used here to extract `body.listaHechos` from the actual JSON.
final class LifeEventsRepositoryImpl implements LifeEventsRepository {
  LifeEventsRepositoryImpl({
    required final Dio dio,
  }) : _api = HechosVitalesApi(withGeneratedApiCompat(dio), standardSerializers);

  final HechosVitalesApi _api;

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async {
    // Actual response shape:
    //   { body: { idAgente, listaHechos: [{ idHecho, nombreHecho, seleccionado }] },
    //     timestamp, mensaje-respuesta, codigo-respuesta, info-error }
    final payload = await _rawResponse(
      () => _api.obtenerListaHechosByIdAgente(
        idAgente: idAgente,
        extra: _generatedExtra,
      ),
    );

    final body = _asStringMap(_asStringMap(payload)?['body']);
    final rawList = body?['listaHechos'] as List<dynamic>?;
    if (rawList == null) {
      return const [];
    }

    return rawList
        .whereType<Map<String, dynamic>>()
        .where((final h) => h['idHecho'] != null)
        .map(
          (final h) => LifeEvent(
            id: (h['idHecho'] as num).toInt(),
            label: (h['nombreHecho'] as String?) ?? '',
            selected: (h['seleccionado'] as bool?) ?? false,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> saveLifeEvents({
    required final String idAgente,
    required final List<LifeEvent> events,
  }) async {
    try {
      await _api.actualizarListaHechos(
        listaHechosAgente: ListaHechosAgente(
          (final builder) => builder
            ..idAgente = idAgente
            ..listaHechos.replace(
              events
                  .map(
                    (final event) => Hecho(
                      (final hecho) => hecho
                        ..idHecho = event.id
                        ..nombreHecho = event.label
                        ..seleccionado = event.selected,
                    ),
                  )
                  .toBuiltList(),
            ),
        ),
        extra: {
          generatedApiRequestDataExtraKey: _requestBody(idAgente, events),
          generatedApiDecodeStringResponseExtraKey: true,
        },
      );
    } on DioException catch (error) {
      if (_isSupportUnavailableResponse(error.response?.data)) {
        throw const LifeEventsSupportUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<void> resetPreferences({required final String idAgente}) async {
    await _api.eliminarPreferencias(
      idAgente: idAgente,
      extra: _generatedExtra,
    );
  }

  Map<String, dynamic> get _generatedExtra => const {
    generatedApiDecodeStringResponseExtraKey: true,
  };

  Map<String, dynamic> _requestBody(final String idAgente, final List<LifeEvent> events) {
    return <String, dynamic>{
      'idAgente': idAgente,
      'listaHechos': events
          .map(
            (final event) => <String, dynamic>{
              'idHecho': event.id,
              'nombreHecho': event.label,
              'seleccionado': event.selected,
            },
          )
          .toList(growable: false),
    };
  }

  Future<Object?> _rawResponse(final Future<Response<Respuesta>> Function() fetch) async {
    try {
      final response = await fetch();
      return response.extra[generatedApiRawResponseDataExtraKey] ?? response.data;
    } on DioException catch (error) {
      final rawData = error.response?.extra[generatedApiRawResponseDataExtraKey] ?? error.response?.data;
      if (rawData != null) {
        return rawData;
      }
      rethrow;
    }
  }

  Map<String, dynamic>? _asStringMap(final Object? value) {
    if (value is Map<String, dynamic>) {
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

  bool _isSupportUnavailableResponse(final Object? data) {
    if (data is! Map<String, dynamic>) {
      return false;
    }
    final responseCode = data['codigo-respuesta']?.toString();
    if (responseCode == '412.00') {
      return true;
    }
    final message = data['mensaje-respuesta']?.toString().toLowerCase() ?? '';
    return message.contains('no se pudo dar de alta el soporte');
  }
}
