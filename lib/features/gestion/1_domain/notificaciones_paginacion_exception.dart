// Pure domain type — no Flutter, no Riverpod, no Dio.

/// El barrido de un estado no pudo completarse: la última página vino llena,
/// así que se sabe que hay más notificaciones y que no se han traído.
///
/// Se prefiere fallar a devolver lo acumulado: una lista parcial presentada
/// como completa esconde notificaciones con plazo, y la pantalla ya sabe
/// mostrar un error con reintento. Es un fallo del contrato del listado (no
/// declara metadatos de paginación), no de transporte, de ahí que sea un tipo
/// de dominio y no una `DioException`.
final class NotificacionesPaginacionIncompletaException implements Exception {
  const NotificacionesPaginacionIncompletaException({
    required this.estado,
    required this.paginas,
    required this.acumuladas,
    required this.motivo,
  });

  /// Token del filtro consultado (`pendiente`, `aceptada`…). No es dato
  /// personal: es el valor de query del contrato.
  final String estado;

  /// Páginas pedidas antes de rendirse.
  final int paginas;

  /// Notificaciones distintas acumuladas hasta ese punto.
  final int acumuladas;

  final String motivo;

  @override
  String toString() => 'NotificacionesPaginacionIncompletaException(estado: $estado, paginas: $paginas, acumuladas: $acumuladas, motivo: $motivo)';
}
