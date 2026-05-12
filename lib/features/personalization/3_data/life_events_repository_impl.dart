import 'package:dio/dio.dart';
import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';

/// Concrete implementation of [LifeEventsRepository] backed by [HechosVitalesApi].
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
  const LifeEventsRepositoryImpl({
    required final HechosVitalesApi api,
    required final Dio dio,
  })  : _api = api,
        _dio = dio;

  final HechosVitalesApi _api;

  /// Raw Dio client used only for [loadLifeEvents] — the GET endpoint returns
  /// a `Respuesta` envelope not reflected in the generated client contract.
  final Dio _dio;

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async {
    // Actual response shape:
    //   { body: { idAgente, listaHechos: [{ idHecho, nombreHecho, seleccionado }] },
    //     timestamp, mensaje-respuesta, codigo-respuesta, info-error }
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/v1/hechos-vitales/hechos/$idAgente',
    );

    final body = response.data?['body'] as Map<String, dynamic>?;
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
    final hechos = events
        .map(
          (final e) => Hecho(
            (final b) => b
              ..idHecho = e.id
              ..nombreHecho = e.label
              ..seleccionado = e.selected,
          ),
        )
        .toList(growable: false);

    await _api.actualizarListaHechos(
      listaHechosAgente: ListaHechosAgente(
        (final b) => b
          ..idAgente = idAgente
          ..listaHechos.replace(hechos),
      ),
    );
  }

  @override
  Future<void> resetPreferences({required final String idAgente}) async {
    await _api.eliminarPreferencias(idAgente: idAgente);
  }
}
