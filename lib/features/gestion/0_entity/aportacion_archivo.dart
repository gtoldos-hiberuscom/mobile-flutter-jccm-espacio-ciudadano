import 'package:meta/meta.dart';

@immutable
final class AportacionArchivo {
  const AportacionArchivo({
    required this.path,
    required this.nombre,
    required this.tamanioBytes,
  });

  /// Identificador único del fichero (ruta del sistema de ficheros).
  final String path;
  final String nombre;
  final int tamanioBytes;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AportacionArchivo && runtimeType == other.runtimeType && path == other.path && nombre == other.nombre && tamanioBytes == other.tamanioBytes;

  @override
  int get hashCode => Object.hash(path, nombre, tamanioBytes);
}
