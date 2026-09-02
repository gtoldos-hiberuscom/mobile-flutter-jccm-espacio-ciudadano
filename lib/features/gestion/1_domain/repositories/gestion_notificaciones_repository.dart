import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';

abstract interface class GestionNotificacionesRepository {
  /// Listado de notificaciones. `estado` null = sin filtro ("Todo"), y en ese
  /// caso el estado de cada elemento puede quedar desconocido.
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final NotificacionEstado? estado,
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
