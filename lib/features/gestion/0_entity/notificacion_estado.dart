/// Estado de una notificación electrónica.
///
/// El listado indexado del backend (`NotificacionIndexaDto`) **no** expone el
/// estado de cada notificación: solo el detalle (`NotificacionDto`) lo informa.
/// Por eso el estado de un resumen puede ser desconocido, y desconocido se
/// representa con `null` — nunca con un valor concreto ni con cadena vacía: dar
/// por hecho un estado es lo que impedía comparecer desde la pestaña "Todo" y
/// etiquetaba como "Expirada" una notificación pendiente.
enum NotificacionEstado {
  pendiente,
  aceptada,
  rechazada,
  expirada,
}
