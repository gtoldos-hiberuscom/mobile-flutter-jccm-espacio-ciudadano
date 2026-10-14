import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';

/// Servidor de versiones: decide si la versión instalada se fuerza, se
/// recomienda o no se toca.
///
/// La implementación conoce la plataforma en la que corre y lanza ante
/// cualquier fallo de transporte o respuesta inválida; el use case convierte
/// ese fallo en «no bloquear» (fail-open).
abstract interface class AppUpdateRepository {
  Future<AppUpdateDecision> fetchDecision({
    required final String applicationId,
    required final AppVersion installedVersion,
  });
}
