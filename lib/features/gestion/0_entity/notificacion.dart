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
