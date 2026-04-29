import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_estado.dart';
import 'package:jccm_espacio_ciudadano/features/casework/detail/0_entity/expediente_fichero.dart';

/// Detail snapshot of an expediente as exposed to the presentation layer
/// (STORY-35). Sourced from `/publicacion/selectbynumexp`.
///
/// Pure data — no Flutter or infrastructure dependencies.
final class ExpedienteDetail {
  const ExpedienteDetail({
    required this.id,
    required this.numero,
    required this.asuntoCodigo,
    required this.asunto,
    required this.consejeria,
    required this.oficinaTramitadora,
    required this.procedimiento,
    required this.fechaInicio,
    required this.fechaUltimaActualizacion,
    required this.estado,
    required this.ficheros,
  });

  /// Stable identifier — never PII content.
  final String id;

  /// Administrative number (e.g. `EXP/2025/00123`).
  final String numero;

  /// Code of the underlying "asunto" (subject classifier).
  final String asuntoCodigo;

  /// Free-text subject line as shown to the citizen.
  final String asunto;

  /// Owning consejería.
  final String consejeria;

  /// Tramitating office.
  final String oficinaTramitadora;

  /// Procedure name.
  final String procedimiento;

  /// Date the expediente was opened.
  final DateTime fechaInicio;

  /// Date of the most recent change to the expediente.
  final DateTime fechaUltimaActualizacion;

  /// Lifecycle state — see [ExpedienteEstado].
  final ExpedienteEstado estado;

  /// Files already associated with this expediente.
  final List<ExpedienteFichero> ficheros;
}
