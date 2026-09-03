import 'package:dio/dio.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';

abstract interface class GestionNotificacionesRepository {
  /// Listado de notificaciones. `estado` null = "Todo": como el listado
  /// indexado del backend no informa el estado de cada elemento, "Todo" se
  /// construye consultando todos los estados y fusionando, de modo que cada
  /// elemento llega etiquetado con el suyo.
  ///
  /// [cancelToken] aborta el barrido: "Todo" lanza cuatro en paralelo y cada
  /// uno puede pedir varias páginas, así que salir de la pantalla tiene que
  /// poder cortarlos.
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final NotificacionEstado? estado,
    final CancelToken? cancelToken,
  });

  /// Detalle de una notificación. `fallbackEstado` es el estado que traía el
  /// resumen (si se conocía) y solo se usa cuando el detalle no informa el
  /// suyo; nunca se inventa un estado si ambos faltan.
  Future<NotificacionDetalle> loadNotificacion({
    required String citizenId,
    required int notificacionId,
    NotificacionEstado? fallbackEstado,
    String? sistemaOrigen,
  });

  Future<void> transitionNotificacion({
    required String citizenId,
    required int notificacionId,
    required String accion,
    String? sistemaOrigen,
    String? justificacion,
  });

  Future<List<int>> downloadDocumento({
    required String citizenId,
    required int notificacionId,
    required int orden,
    String? sistemaOrigen,
  });
}
