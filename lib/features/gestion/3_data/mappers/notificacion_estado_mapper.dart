import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';

/// Valor del parámetro `estado` del listado
/// `GET /api/v1/ciudadanos/{id}/notificaciones`.
String notificacionEstadoQueryValue(final NotificacionEstado estado) => switch (estado) {
  NotificacionEstado.pendiente => 'pendiente',
  NotificacionEstado.aceptada => 'aceptada',
  NotificacionEstado.rechazada => 'rechazada',
  NotificacionEstado.expirada => 'expirada',
};

/// Traduce el estado que informa el backend.
///
/// Devuelve `null` cuando el campo no viene o trae un valor que no
/// reconocemos: "no lo sé" no se convierte nunca en un estado concreto.
///
/// Se aceptan los dos vocabularios del contrato: el del filtro del listado
/// (`pendiente|aceptada|rechazada|expirada`) y el del histórico de Notifica,
/// en mayúsculas y con guion bajo (`PUESTO_A_DISPOSICION`, `ACEPTADA`…).
NotificacionEstado? notificacionEstadoFromBackend(final String? raw) {
  final normalized = raw?.trim().toLowerCase().replaceAll('-', '_');
  return switch (normalized) {
    'pendiente' || 'puesto_a_disposicion' || 'puesta_a_disposicion' => NotificacionEstado.pendiente,
    'aceptada' || 'aceptado' => NotificacionEstado.aceptada,
    'rechazada' || 'rechazado' => NotificacionEstado.rechazada,
    'expirada' || 'expirado' || 'caducada' => NotificacionEstado.expirada,
    _ => null,
  };
}
