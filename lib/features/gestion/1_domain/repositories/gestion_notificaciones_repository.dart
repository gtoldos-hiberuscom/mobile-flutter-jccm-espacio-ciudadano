import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion.dart';
import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_detalle.dart';

abstract interface class GestionNotificacionesRepository {
  Future<List<Notificacion>> loadNotificaciones({
    required final String citizenId,
    final String? estado,
  });

  Future<NotificacionDetalle> loadNotificacion({
    required String citizenId,
    required int notificacionId,
    required String estado,
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
