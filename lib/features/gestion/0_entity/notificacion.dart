import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:meta/meta.dart';

@immutable
final class Notificacion {
  const Notificacion({
    required this.id,
    required this.concepto,
    required this.procedimientoDenominacion,
    this.fechaCaducidad,
    this.procedimientoIdFicha,
    this.unidadOrganicaNombre,
    this.sistemaOrigen,
    this.estado,
  });

  final int id;
  final String concepto;
  final String procedimientoDenominacion;
  final DateTime? fechaCaducidad;
  final String? procedimientoIdFicha;
  final String? unidadOrganicaNombre;
  final String? sistemaOrigen;

  /// Estado de la notificación, o `null` si no se conoce.
  ///
  /// El DTO indexado no lo expone: solo se conoce cuando el propio elemento del
  /// listado lo informa o cuando se consultó filtrando por un estado concreto.
  /// La pestaña "Todo" consulta los cuatro estados del contrato y fusiona, así
  /// que también llega informado; si el backend dejara de clasificar alguna
  /// notificación, `null` sigue significando "no lo sé" y el estado real lo
  /// aporta el detalle (`NotificacionDetalle.estado`).
  final NotificacionEstado? estado;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Notificacion && runtimeType == other.runtimeType && id == other.id && concepto == other.concepto && procedimientoDenominacion == other.procedimientoDenominacion && fechaCaducidad == other.fechaCaducidad && procedimientoIdFicha == other.procedimientoIdFicha && unidadOrganicaNombre == other.unidadOrganicaNombre && sistemaOrigen == other.sistemaOrigen && estado == other.estado;

  @override
  int get hashCode => Object.hash(
    id,
    concepto,
    procedimientoDenominacion,
    fechaCaducidad,
    procedimientoIdFicha,
    unidadOrganicaNombre,
    sistemaOrigen,
    estado,
  );
}

/// Elige, entre dos vistas del mismo elemento, la que informa el estado más
/// nuevo según [notificacionEstadoPrecedence].
///
/// Devuelve [candidate] solo si su estado tiene precedencia **estrictamente**
/// mayor; el empate conserva [current], de modo que fusionar es determinista y
/// no depende del orden en que terminen las consultas.
Notificacion pickByNotificacionEstadoPrecedence(final Notificacion current, final Notificacion candidate) {
  return notificacionEstadoPrecedence(candidate.estado) > notificacionEstadoPrecedence(current.estado) ? candidate : current;
}

/// Orden de bandeja para la pestaña "Todo": primero lo que requiere acción,
/// por urgencia; después el histórico, por recencia.
///
/// La fusión de los cuatro barridos no puede reconstruir el orden del backend
/// —no hay clave común entre listas filtradas—, así que "Todo" necesita un
/// criterio propio. Las pendientes van arriba ordenadas por `fechaCaducidad`
/// **ascendente** (la que caduca antes, primero: es el dato que la tarjeta
/// resalta en ámbar), y el resto detrás por `fechaCaducidad` **descendente**,
/// que en Notifica aproxima "lo más reciente primero" porque la caducidad es la
/// puesta a disposición más la ventana de acceso — el listado indexado no
/// informa la fecha de alta, solo el detalle.
///
/// Sin fecha, la notificación cae al final de su grupo; el desempate final es
/// por `id` descendente para que el orden sea total y estable entre recargas.
int compareNotificacionesForInbox(final Notificacion a, final Notificacion b) {
  final aPendiente = a.estado == NotificacionEstado.pendiente;
  final bPendiente = b.estado == NotificacionEstado.pendiente;
  if (aPendiente != bPendiente) {
    return aPendiente ? -1 : 1;
  }
  final aFecha = a.fechaCaducidad;
  final bFecha = b.fechaCaducidad;
  if (aFecha == null || bFecha == null) {
    if (aFecha != null) {
      return -1;
    }
    if (bFecha != null) {
      return 1;
    }
    return b.id.compareTo(a.id);
  }
  final byFecha = aPendiente ? aFecha.compareTo(bFecha) : bFecha.compareTo(aFecha);
  return byFecha != 0 ? byFecha : b.id.compareTo(a.id);
}
