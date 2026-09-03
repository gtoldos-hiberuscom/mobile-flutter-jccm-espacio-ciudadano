import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';

/// Valor del parámetro `estado` del listado
/// `GET /api/v1/ciudadanos/{id}/notificaciones`.
String notificacionEstadoQueryValue(final NotificacionEstado estado) => switch (estado) {
  NotificacionEstado.pendiente => 'pendiente',
  NotificacionEstado.aceptada => 'aceptada',
  NotificacionEstado.rechazada => 'rechazada',
  NotificacionEstado.expirada => 'expirada',
};

/// Resultado de leer el campo `estado` del backend.
///
/// "No vino" y "vino algo que no reconocemos" no significan lo mismo: lo
/// primero deja sitio al estado que ya se conocía por el resumen; lo segundo
/// dice que el backend clasifica la notificación en algo que esta app no sabe
/// leer, y respaldarlo con el resumen resucitaba la acción de comparecer sobre
/// algo que el backend había declarado en otro estado.
///
/// El tipo obliga a cada consumidor a decidir qué hace con cada caso, que es
/// justo lo que faltaba.
sealed class NotificacionEstadoLectura {
  const NotificacionEstadoLectura();
}

final class NotificacionEstadoConocido extends NotificacionEstadoLectura {
  const NotificacionEstadoConocido(this.estado);

  final NotificacionEstado estado;
}

/// El campo no vino, o vino vacío.
final class NotificacionEstadoAusente extends NotificacionEstadoLectura {
  const NotificacionEstadoAusente();
}

/// Vino un valor fuera del vocabulario documentado — Notifica tiene más del que
/// recoge el contrato. [raw] se conserva para la traza: es lo único que permite
/// descubrir qué vocabulario falta.
final class NotificacionEstadoNoReconocido extends NotificacionEstadoLectura {
  const NotificacionEstadoNoReconocido(this.raw);

  final String raw;
}

/// Lee el estado que informa el backend distinguiendo ausencia de valor
/// desconocido.
///
/// Se aceptan los dos vocabularios del contrato: el del filtro del listado
/// (`pendiente|aceptada|rechazada|expirada`) y el del histórico de Notifica,
/// en mayúsculas y con guion bajo (`PUESTO_A_DISPOSICION`, `ACEPTADA`…).
NotificacionEstadoLectura notificacionEstadoLecturaFromBackend(final String? raw) {
  final trimmed = raw?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return const NotificacionEstadoAusente();
  }
  return switch (trimmed.toLowerCase().replaceAll('-', '_')) {
    'pendiente' || 'puesto_a_disposicion' || 'puesta_a_disposicion' => const NotificacionEstadoConocido(NotificacionEstado.pendiente),
    'aceptada' || 'aceptado' => const NotificacionEstadoConocido(NotificacionEstado.aceptada),
    'rechazada' || 'rechazado' => const NotificacionEstadoConocido(NotificacionEstado.rechazada),
    'expirada' || 'expirado' || 'caducada' => const NotificacionEstadoConocido(NotificacionEstado.expirada),
    _ => NotificacionEstadoNoReconocido(trimmed),
  };
}

/// Vista corta de [notificacionEstadoLecturaFromBackend]: colapsa ausente y no
/// reconocido en `null`.
///
/// Úsala solo donde da igual **por qué** no se conoce el estado; el detalle
/// necesita la distinción.
NotificacionEstado? notificacionEstadoFromBackend(final String? raw) => switch (notificacionEstadoLecturaFromBackend(raw)) {
  NotificacionEstadoConocido(:final estado) => estado,
  NotificacionEstadoAusente() || NotificacionEstadoNoReconocido() => null,
};
