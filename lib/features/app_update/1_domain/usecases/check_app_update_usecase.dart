import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_info.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_preferences_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';

// ── Sealed result ─────────────────────────────────────────────────────────────

sealed class CheckAppUpdateResult {
  const CheckAppUpdateResult();
}

/// Nada que avisar: la app está al día, la política es `none` o la recomendada
/// publicada ya fue descartada por el ciudadano.
final class UpdateNotRequired extends CheckAppUpdateResult {
  const UpdateNotRequired();
}

/// Hay que avisar; [info] dice si es forzada o recomendada.
final class UpdateAvailable extends CheckAppUpdateResult {
  const UpdateAvailable(this.info);

  final AppUpdateInfo info;
}

/// La comprobación no pudo hacerse (manifiesto inválido, fallo de transporte,
/// versión instalada ilegible). Quien lo recibe **no bloquea** al ciudadano.
final class CheckAppUpdateFailed extends CheckAppUpdateResult {
  const CheckAppUpdateFailed({required this.message, this.cause});

  final String message;
  final Object? cause;
}

// ── Use case ──────────────────────────────────────────────────────────────────

/// Decide si hay que avisar de una actualización y de qué tipo.
///
/// Regla: instalada < mínima → forzada; instalada < última → la política del
/// manifiesto; si no, nada. Una recomendada no se repite si el ciudadano ya
/// descartó esa versión (o una posterior); una forzada se muestra siempre.
final class CheckAppUpdateUsecase {
  const CheckAppUpdateUsecase({
    required final AppUpdateRepository manifests,
    required final InstalledVersionRepository installedVersions,
    required final AppUpdatePreferencesRepository preferences,
  }) : _manifests = manifests,
       _installedVersions = installedVersions,
       _preferences = preferences;

  final AppUpdateRepository _manifests;
  final InstalledVersionRepository _installedVersions;
  final AppUpdatePreferencesRepository _preferences;

  Future<CheckAppUpdateResult> execute() async {
    try {
      final installed = await _installedVersions.installedVersion();
      final manifest = await _manifests.fetchManifest();
      final policy = _resolvePolicy(installed: installed, manifest: manifest);

      if (policy == UpdatePolicy.none) {
        return const UpdateNotRequired();
      }
      if (policy == UpdatePolicy.recommended) {
        final ignored = await _preferences.readIgnoredVersion();
        if (ignored != null && manifest.latestVersion <= ignored) {
          return const UpdateNotRequired();
        }
      }
      return UpdateAvailable(
        AppUpdateInfo(
          policy: policy,
          latestVersion: manifest.latestVersion,
          storeUrl: manifest.storeUrl,
        ),
      );
    } on Object catch (e) {
      return CheckAppUpdateFailed(message: e.toString(), cause: e);
    }
  }

  static UpdatePolicy _resolvePolicy({
    required final AppVersion installed,
    required final AppUpdateManifest manifest,
  }) {
    if (installed < manifest.minVersion) {
      return UpdatePolicy.forced;
    }
    if (installed < manifest.latestVersion) {
      return manifest.policy;
    }
    return UpdatePolicy.none;
  }
}
