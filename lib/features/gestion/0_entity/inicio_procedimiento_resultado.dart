import 'package:meta/meta.dart';

/// Resultado de `procedimiento/inicproc`. Sus campos son exactamente los que
/// exige `PDATOS` al cerrar la transacción con `registrarfichero` — el
/// manual de integración describe ese cierre como un eco directo de esta
/// respuesta.
@immutable
final class InicioProcedimientoResultado {
  const InicioProcedimientoResultado({
    required this.idunico,
    required this.estado,
    required this.asuid,
    required this.descrip,
    required this.uniorg,
    required this.numdoc,
    required this.nombre,
    required this.apellido1,
    required this.apellido2,
  });

  /// Idunico confirmado por el servidor — puede diferir del enviado (el
  /// backend puede ajustarlo); es este el que debe usarse en las llamadas
  /// siguientes, no el generado localmente.
  final String idunico;

  /// `"OK"` si la transacción se abrió correctamente.
  final String estado;

  final String asuid;
  final String descrip;
  final String uniorg;
  final String numdoc;
  final String nombre;
  final String apellido1;
  final String apellido2;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is InicioProcedimientoResultado && runtimeType == other.runtimeType && idunico == other.idunico && estado == other.estado && asuid == other.asuid && descrip == other.descrip && uniorg == other.uniorg && numdoc == other.numdoc && nombre == other.nombre && apellido1 == other.apellido1 && apellido2 == other.apellido2;

  @override
  int get hashCode => Object.hash(idunico, estado, asuid, descrip, uniorg, numdoc, nombre, apellido1, apellido2);
}
