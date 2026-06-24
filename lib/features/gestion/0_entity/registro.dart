import 'package:meta/meta.dart';

@immutable
final class Registro {
  const Registro({
    required this.numregistro,
    required this.titulo,
    this.fecha,
    this.consejeria,
  });

  final String numregistro;
  final String titulo;
  final String? fecha;
  final String? consejeria;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is Registro &&
          runtimeType == other.runtimeType &&
          numregistro == other.numregistro &&
          titulo == other.titulo &&
          fecha == other.fecha &&
          consejeria == other.consejeria;

  @override
  int get hashCode => Object.hash(numregistro, titulo, fecha, consejeria);

  Registro copyWith({
    final String? numregistro,
    final String? titulo,
    final String? fecha,
    final String? consejeria,
  }) {
    return Registro(
      numregistro: numregistro ?? this.numregistro,
      titulo: titulo ?? this.titulo,
      fecha: fecha ?? this.fecha,
      consejeria: consejeria ?? this.consejeria,
    );
  }
}
