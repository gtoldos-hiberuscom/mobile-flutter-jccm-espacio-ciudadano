import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_decision_dto.dart';

/// DTO → entidad. Cualquier dato que no cuadre lanza [FormatException] y el
/// use case lo convierte en «no bloquear».
final class AppUpdateDecisionMapper {
  const AppUpdateDecisionMapper._();

  static AppUpdateDecision fromDto(final AppUpdateDecisionDto dto) {
    final policy = switch (dto.accion) {
      'NINGUNA' => UpdatePolicy.none,
      'RECOMENDADA' => UpdatePolicy.recommended,
      'FORZADA' => UpdatePolicy.forced,
      final other => throw FormatException('Unknown update action "$other"'),
    };
    if (policy == UpdatePolicy.none) {
      return const AppUpdateDecision.none();
    }

    final rawVersion = dto.versionPublicada;
    if (rawVersion == null) {
      throw FormatException('Missing "versionPublicada" for action ${dto.accion}');
    }
    final message = dto.mensaje?.trim();
    return AppUpdateDecision(
      policy: policy,
      publishedVersion: AppVersion.parse(rawVersion),
      message: message == null || message.isEmpty ? null : message,
    );
  }
}
