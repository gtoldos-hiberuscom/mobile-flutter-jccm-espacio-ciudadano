import 'package:meta/meta.dart';

@immutable
final class Expediente {
  const Expediente({
    required this.numexp,
    required this.titulo,
    required this.consejeria,
    this.fechaInicio,
    this.estado,
  });

  final String numexp;
  final String titulo;
  final String consejeria;
  final String? fechaInicio;
  final String? estado;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is Expediente && runtimeType == other.runtimeType && numexp == other.numexp && titulo == other.titulo && consejeria == other.consejeria && fechaInicio == other.fechaInicio && estado == other.estado;

  @override
  int get hashCode => Object.hash(numexp, titulo, consejeria, fechaInicio, estado);

  Expediente copyWith({
    final String? numexp,
    final String? titulo,
    final String? consejeria,
    final String? fechaInicio,
    final String? estado,
  }) {
    return Expediente(
      numexp: numexp ?? this.numexp,
      titulo: titulo ?? this.titulo,
      consejeria: consejeria ?? this.consejeria,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      estado: estado ?? this.estado,
    );
  }
}
