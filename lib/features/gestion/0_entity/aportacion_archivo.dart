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
    this.hash,
  });

  /// Identificador único del fichero (ruta del sistema de ficheros).
  final String path;
  final String nombre;
  final int tamanioBytes;
  final AportacionArchivoEstado estado;

  /// Progreso de subida en `[0.0, 1.0]`. Solo relevante cuando
  /// `estado == AportacionArchivoEstado.enviando`.
  final double? progreso;

  /// Hash devuelto por `subiradjuntosinfirma` al completar la subida —
  /// necesario para construir `documentos` al llamar a `registrarfichero`.
  /// Solo relevante cuando `estado == AportacionArchivoEstado.completado`.
  final String? hash;

  /// [clearProgreso]/[clearHash] resetean su campo a `null`
  /// independientemente de [progreso]/[hash] — necesario porque pasar
  /// `null` directamente es indistinguible de "mantener el valor actual"
  /// bajo el convenio habitual `??` de copyWith.
  AportacionArchivo copyWith({
    final AportacionArchivoEstado? estado,
    final double? progreso,
    final bool clearProgreso = false,
    final String? hash,
    final bool clearHash = false,
  }) {
    return AportacionArchivo(
      path: path,
      nombre: nombre,
      tamanioBytes: tamanioBytes,
      estado: estado ?? this.estado,
      progreso: clearProgreso ? null : (progreso ?? this.progreso),
      hash: clearHash ? null : (hash ?? this.hash),
    );
  }

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AportacionArchivo && runtimeType == other.runtimeType && path == other.path && nombre == other.nombre && tamanioBytes == other.tamanioBytes && estado == other.estado && progreso == other.progreso && hash == other.hash;

  @override
  int get hashCode => Object.hash(path, nombre, tamanioBytes, estado, progreso, hash);
}
