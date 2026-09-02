import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_envelope.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/life_event.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/api/hechos_api.dart';

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
/// La respuesta llega en el sobre habitual: `{ body: { idAgente, listaHechos },
/// timestamp, mensaje-respuesta, codigo-respuesta, info-error }`.
final class LifeEventsRepositoryImpl implements LifeEventsRepository {
  LifeEventsRepositoryImpl({
    required final Dio dio,
    final String? agentId,
  }) : _agentId = agentId?.trim(),
       _api = HechosApi(dio);

  final HechosApi _api;
  final String? _agentId;

  @override
  Future<List<LifeEvent>> loadLifeEvents({required final String idAgente}) async {
    // body.listaHechos: [{ idHecho, nombreHecho, seleccionado }]
    final envelope = await _obtenerHechos(idAgente);
    final body = _asStringMap(envelope?['body']);
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
      await _api.actualizarHechos(
        citizenId: idAgente,
        body: _requestBody(_requestAgentId(idAgente), events),
      );
    } on DioException catch (error) {
      if (_isSupportUnavailableResponse(decodeApiEnvelope(error.response?.data))) {
        throw const LifeEventsSupportUnavailableException();
      }
      rethrow;
    }
  }

  @override
  Future<void> resetPreferences({required final String idAgente}) async {
    await _api.eliminarPreferencias(citizenId: idAgente);
  }

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

  String _requestAgentId(final String citizenId) {
    final agentId = _agentId;
    return agentId == null || agentId.isEmpty ? citizenId : agentId;
  }

  /// Un 4xx solo se aprovecha si su sobre trae realmente el listado
  /// (`body.listaHechos`); cualquier otro error se propaga. Aceptar un sobre de
  /// error genérico fabricaba un "no tienes hechos configurados" falso durante
  /// caídas del backend.
  Future<Map<String, dynamic>?> _obtenerHechos(final String idAgente) async {
    try {
      return await _api.obtenerHechos(citizenId: idAgente);
    } on DioException catch (error) {
      final envelope = decodeApiEnvelope(error.response?.data);
      final body = _asStringMap(envelope?['body']);
      if (envelope != null && body?['listaHechos'] is List) {
        return envelope;
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

  bool _isSupportUnavailableResponse(final Map<String, dynamic>? data) {
    if (data == null) {
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
