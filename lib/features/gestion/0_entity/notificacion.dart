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
  /// En la pestaña "Todo" no hay filtro, así que aquí llega `null` y el estado
  /// real lo aporta el detalle (`NotificacionDetalle.estado`).
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
