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
  final String estado;
  final String? organismo;
  final String? procedimiento;
  final String? expediente;
  final DateTime? fechaPuestaDisposicion;
  final DateTime? fechaExpiracion;
  final DateTime? fechaLectura;
  final String? sistemaOrigen;
  final List<NotificacionDocumento> documentos;
}
