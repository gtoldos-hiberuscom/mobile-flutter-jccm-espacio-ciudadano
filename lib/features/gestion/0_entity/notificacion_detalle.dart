import 'package:jccm_espacio_ciudadano/features/gestion/0_entity/notificacion_estado.dart';
import 'package:meta/meta.dart';

@immutable
final class NotificacionDocumento {
  const NotificacionDocumento({required this.orden, required this.nombre, this.tamanoBytes});

  final int orden;
  final String nombre;
  final int? tamanoBytes;
}

@immutable
final class NotificacionDetalle {
  const NotificacionDetalle({
    required this.id,
    required this.titulo,
    required this.estado,
    required this.documentos,
    this.organismo,
    this.procedimiento,
    this.expediente,
    this.fechaPuestaDisposicion,
    this.fechaExpiracion,
    this.fechaLectura,
    this.sistemaOrigen,
  });

  final int id;
  final String titulo;

  /// Estado que informa el detalle, o `null` si el backend no lo envía y
  /// tampoco se conocía por el resumen. Es la fuente de verdad para la acción
  /// de comparecencia y para la etiqueta de estado.
  final NotificacionEstado? estado;
  final String? organismo;
  final String? procedimiento;
  final String? expediente;
  final DateTime? fechaPuestaDisposicion;
  final DateTime? fechaExpiracion;
  final DateTime? fechaLectura;
  final String? sistemaOrigen;
  final List<NotificacionDocumento> documentos;
}
