import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_info.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class CheckAppUpdateResult {
  const CheckAppUpdateResult();
}

/// Nada que avisar: el servidor no pide nada o la recomendada ya fue
/// descartada por el ciudadano.
final class UpdateNotRequired extends CheckAppUpdateResult {
  const UpdateNotRequired();
}

/// Hay que avisar; [info] dice si es forzada o recomendada.
final class UpdateAvailable extends CheckAppUpdateResult {
  const UpdateAvailable(this.info);

  final AppUpdateInfo info;
}

/// La comprobación no pudo hacerse (fallo de transporte, respuesta inválida o
/// incoherente, versión instalada ilegible). Quien lo recibe **no bloquea** al
/// ciudadano.
final class CheckAppUpdateFailed extends CheckAppUpdateResult {
  const CheckAppUpdateFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Pregunta al servidor de versiones qué hacer con la versión instalada.
///
/// La decisión es del servidor; aquí solo se comprueba que sea coherente (una
/// forzada o recomendada debe traer una versión publicada **mayor** que la
/// instalada; si no, se trata como fallo y no se bloquea a nadie). Una
/// recomendada no se repite si el ciudadano ya descartó esa versión (o una
/// posterior); una forzada se muestra siempre.
final class CheckAppUpdateUsecase {
  const CheckAppUpdateUsecase({
    required final AppUpdateRepository decisions,
    required final InstalledVersionRepository installedVersions,
    required final AppUpdatePreferencesRepository preferences,
  }) : _decisions = decisions,
       _installedVersions = installedVersions,
       _preferences = preferences;

  final AppUpdateRepository _decisions;
  final InstalledVersionRepository _installedVersions;
  final AppUpdatePreferencesRepository _preferences;

  Future<CheckAppUpdateResult> execute() async {
    try {
      final installed = await _installedVersions.installedVersion();
      final applicationId = await _installedVersions.applicationId();
      final decision = await _decisions.fetchDecision(applicationId: applicationId, installedVersion: installed);

      if (decision.policy == UpdatePolicy.none) {
        return const UpdateNotRequired();
      }
      final published = decision.publishedVersion;
      if (published == null || published <= installed) {
        return CheckAppUpdateFailed(message: 'Inconsistent update decision: ${decision.policy.name} to $published with $installed installed');
      }
      if (decision.policy == UpdatePolicy.recommended) {
        final ignored = await _preferences.readIgnoredVersion();
        if (ignored != null && published <= ignored) {
          return const UpdateNotRequired();
        }
      }
      return UpdateAvailable(
        AppUpdateInfo(
          policy: decision.policy,
          latestVersion: published,
          message: decision.message,
        ),
      );
    } on Object catch (e) {
      return CheckAppUpdateFailed(message: e.toString(), cause: e);
    }
  }
}
