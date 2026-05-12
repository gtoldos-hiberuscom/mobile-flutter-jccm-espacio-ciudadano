import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_repository.dart';

/// Concrete implementation of [LifeEventsRepository] backed by [HechosVitalesApi].
///
/// Lives in `3_data/` — all API types are mapped to domain entities before
/// returning. No generated model, DTO, or Dio type escapes this class.
final class LifeEventsRepositoryImpl implements LifeEventsRepository {
  const LifeEventsRepositoryImpl({required final HechosVitalesApi api})
      : _api = api;

  final HechosVitalesApi _api;

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async {
    final response =
        await _api.obtenerListaHechosByIdAgente(idAgente: idAgente);
    final list = response.data?.listaHechos;
    if (list == null) {
      return const [];
    }
    return list
        .where((final h) => h.idHecho != null)
        .map(
          (final h) => LifeEvent(
            id: h.idHecho!,
            label: h.nombreHecho ?? '',
            selected: h.seleccionado ?? false,
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
