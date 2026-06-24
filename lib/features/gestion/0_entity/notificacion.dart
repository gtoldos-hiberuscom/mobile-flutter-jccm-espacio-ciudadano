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
  });

  final int id;
  final String concepto;
  final String procedimientoDenominacion;
  final DateTime? fechaCaducidad;
  final String? procedimientoIdFicha;
  final String? unidadOrganicaNombre;
  final String? sistemaOrigen;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Notificacion &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          concepto == other.concepto &&
          procedimientoDenominacion == other.procedimientoDenominacion &&
          fechaCaducidad == other.fechaCaducidad &&
          procedimientoIdFicha == other.procedimientoIdFicha &&
          unidadOrganicaNombre == other.unidadOrganicaNombre &&
          sistemaOrigen == other.sistemaOrigen;

  @override
  int get hashCode => Object.hash(
    id,
    concepto,
    procedimientoDenominacion,
    fechaCaducidad,
    procedimientoIdFicha,
    unidadOrganicaNombre,
    sistemaOrigen,
  );
}
