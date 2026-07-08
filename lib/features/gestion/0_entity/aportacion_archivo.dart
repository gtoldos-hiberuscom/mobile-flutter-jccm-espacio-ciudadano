import 'package:meta/meta.dart';

enum AportacionArchivoEstado { noEnviado, enviando, completado, error }

@immutable
final class AportacionArchivo {
  const AportacionArchivo({
    required this.path,
    required this.nombre,
    required this.tamanioBytes,
    this.estado = AportacionArchivoEstado.noEnviado,
    this.progreso,
  });

  /// Identificador único del fichero (ruta del sistema de ficheros).
  final String path;
  final String nombre;
  final int tamanioBytes;
  final AportacionArchivoEstado estado;

  /// Progreso de subida en `[0.0, 1.0]`. Solo relevante cuando
  /// `estado == AportacionArchivoEstado.enviando`.
  final double? progreso;

  /// [clearProgreso] resets [progreso] to `null` regardless of [progreso] —
  /// needed because `progreso: null` alone is indistinguishable from "keep
  /// the current value" under the usual `??` copyWith convention.
  AportacionArchivo copyWith({
    final AportacionArchivoEstado? estado,
    final double? progreso,
    final bool clearProgreso = false,
  }) {
    return AportacionArchivo(
      path: path,
      nombre: nombre,
      tamanioBytes: tamanioBytes,
      estado: estado ?? this.estado,
      progreso: clearProgreso ? null : (progreso ?? this.progreso),
    );
  }

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AportacionArchivo && runtimeType == other.runtimeType && path == other.path && nombre == other.nombre && tamanioBytes == other.tamanioBytes && estado == other.estado && progreso == other.progreso;

  @override
  int get hashCode => Object.hash(path, nombre, tamanioBytes, estado, progreso);
}
