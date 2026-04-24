import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_fichero.dart';
import 'package:jccm_espacio_ciudadano/features/casework/registro/0_entity/registro_kind.dart';

/// Detail of a registro entry (entrada or salida) for STORY-36.
///
/// Pure-Dart entity — locale-independent and free of Flutter / Riverpod
/// imports per the architecture canon.
final class RegistroDetail {
  const RegistroDetail({
    required this.id,
    required this.numero,
    required this.fecha,
    required this.kind,
    required this.consejeriaDestino,
    required this.asunto,
    required this.oficina,
    required this.ficheros,
    this.observaciones,
  });

  /// Stable opaque identifier returned by the backend.
  final String id;

  /// Administrative number shown to the citizen (e.g. `REG/E/45612`).
  final String numero;

  /// Date the registro was registered.
  final DateTime fecha;

  /// Whether this is an entrada or a salida.
  final RegistroKind kind;

  /// Consejería receiving (entrada) or issuing (salida) the registro.
  final String consejeriaDestino;

  /// Asunto / subject line as published by the back-office.
  final String asunto;

  /// Oficina de registro that processed the entry.
  final String oficina;

  /// Optional free-text observaciones — may be `null` when the backend
  /// returns nothing.
  final String? observaciones;

  /// Read-only list of attached ficheros. Empty list is a valid state
  /// and drives the empty UI in `2_presentation/`.
  final List<RegistroFichero> ficheros;
}
