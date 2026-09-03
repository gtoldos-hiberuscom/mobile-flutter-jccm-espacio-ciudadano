/// Estado de una notificación electrónica.
///
/// El listado indexado del backend (`NotificacionIndexaDto`) **no** expone el
/// estado de cada notificación: solo el detalle (`NotificacionDto`) lo informa.
/// En el listado el estado se conoce porque se consultó filtrando por uno, así
/// que la pestaña "Todo" consulta los cuatro y fusiona
/// (`GestionNotificacionesRepositoryImpl.loadNotificaciones`).
/// Cuando aun así no se conoce, se representa con `null` — nunca con un valor
/// concreto ni con cadena vacía: dar por hecho un estado es lo que impedía
/// comparecer desde "Todo" y etiquetaba como "Expirada" una notificación
/// pendiente.
enum NotificacionEstado {
  pendiente,
  aceptada,
  rechazada,
  expirada,
}

/// Precedencia de un estado al fusionar dos vistas del mismo elemento.
///
/// La pestaña "Todo" se construye consultando los cuatro estados del contrato
/// (el listado indexado no informa el estado), así que un mismo elemento puede
/// llegar por dos barridos: solo ocurre si la notificación transitó mientras se
/// consultaba. `pendiente` es el único estado no terminal, de modo que
/// cualquier estado terminal es el dato más nuevo y gana. Un estado desconocido
/// (`null`) nunca desplaza a uno conocido.
int notificacionEstadoPrecedence(final NotificacionEstado? estado) => switch (estado) {
  NotificacionEstado.aceptada => 4,
  NotificacionEstado.rechazada => 3,
  NotificacionEstado.expirada => 2,
  NotificacionEstado.pendiente => 1,
  null => 0,
};
