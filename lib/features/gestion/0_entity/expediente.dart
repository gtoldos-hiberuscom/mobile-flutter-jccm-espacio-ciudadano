import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/expediente_aportacion_datos.dart';
import 'package:meta/meta.dart';

@immutable
final class Expediente {
  const Expediente({
    required this.numexp,
    required this.titulo,
    required this.consejeria,
    this.fechaInicio,
    this.estado,
    this.oficinaTramitadora,
    this.fechaFin,
    this.tipoproc,
    this.datosAportacion,
  });

  final String numexp;
  final String titulo;
  final String consejeria;
  final String? fechaInicio;
  final String? estado;
  final String? oficinaTramitadora;
  final String? fechaFin;

  /// Código de tipo de procedimiento (ej. `"020"`), usado para aportar
  /// documentación adicional al expediente.
  final String? tipoproc;

  /// Campos adicionales del expediente necesarios para `inicproc`/
  /// `registrarfichero` al aportar documentación. Solo se rellena en el
  /// detalle de expediente, no en el listado.
  final ExpedienteAportacionDatos? datosAportacion;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Expediente && runtimeType == other.runtimeType && numexp == other.numexp && titulo == other.titulo && consejeria == other.consejeria && fechaInicio == other.fechaInicio && estado == other.estado && oficinaTramitadora == other.oficinaTramitadora && fechaFin == other.fechaFin && tipoproc == other.tipoproc && datosAportacion == other.datosAportacion;

  @override
  int get hashCode => Object.hash(numexp, titulo, consejeria, fechaInicio, estado, oficinaTramitadora, fechaFin, tipoproc, datosAportacion);

  Expediente copyWith({
    final String? numexp,
    final String? titulo,
    final String? consejeria,
    final String? fechaInicio,
    final String? estado,
    final String? oficinaTramitadora,
    final String? fechaFin,
    final String? tipoproc,
    final ExpedienteAportacionDatos? datosAportacion,
  }) {
    return Expediente(
      numexp: numexp ?? this.numexp,
      titulo: titulo ?? this.titulo,
      consejeria: consejeria ?? this.consejeria,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      estado: estado ?? this.estado,
      oficinaTramitadora: oficinaTramitadora ?? this.oficinaTramitadora,
      fechaFin: fechaFin ?? this.fechaFin,
      tipoproc: tipoproc ?? this.tipoproc,
      datosAportacion: datosAportacion ?? this.datosAportacion,
    );
  }
}
