import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/play_update_info_dto.dart';

/// Respuesta de Google Play → manifiesto, en espacio de `versionCode`
/// (`0.0.N`), porque Play solo sabe comparar códigos de versión.
///
/// - Sin actualización: `latestVersion = instalada`, nada que avisar.
/// - Con actualización: `latestVersion = 0.0.availableVersionCode`; si la
///   release se publicó con prioridad ≥ [forcedUpdatePriorityThreshold],
///   también es la mínima (forzada). `displayVersion` va vacío: el ciudadano
///   no debe ver «versión 12».
final class PlayManifestMapper {
  const PlayManifestMapper._();

  /// Prioridad in-app (0–5) a partir de la que la actualización es obligatoria.
  /// Solo se puede fijar al publicar con la Google Play Developer API.
  static const int forcedUpdatePriorityThreshold = 4;

  static AppUpdateManifest fromDto(
    final PlayUpdateInfoDto dto, {
    required final AppVersion installed,
    required final String packageName,
  }) {
    final storeUrl = Uri.https('play.google.com', '/store/apps/details', {'id': packageName});

    if (!dto.updateAvailable) {
      return AppUpdateManifest(
        latestVersion: installed,
        minVersion: const AppVersion(0, 0, 0),
        policy: UpdatePolicy.recommended,
        storeUrl: storeUrl,
      );
    }

    final code = dto.availableVersionCode;
    if (code == null || code < 0) {
      throw const FormatException('Google Play reported an update without a versionCode');
    }
    final latestVersion = AppVersion(0, 0, code);
    final forced = dto.updatePriority >= forcedUpdatePriorityThreshold;
    return AppUpdateManifest(
      latestVersion: latestVersion,
      minVersion: forced ? latestVersion : const AppVersion(0, 0, 0),
      policy: UpdatePolicy.recommended,
      storeUrl: storeUrl,
    );
  }
}
