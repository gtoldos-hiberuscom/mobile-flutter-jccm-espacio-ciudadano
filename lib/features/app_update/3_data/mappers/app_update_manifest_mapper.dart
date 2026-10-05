import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_manifest_dto.dart';

/// DTO → entidad. Es el único punto de validación del manifiesto: cualquier
/// dato que no cuadre lanza [FormatException] y el use case lo convierte en
/// «no bloquear».
final class AppUpdateManifestMapper {
  const AppUpdateManifestMapper._();

  /// Resuelve la entrada de [platformKey] (`android` | `ios`) a entidad.
  static AppUpdateManifest fromDto(final AppUpdateManifestDto dto, {required final String platformKey}) {
    final platform = dto.forPlatform(platformKey);
    if (platform == null) {
      throw FormatException('No update manifest entry for platform "$platformKey"');
    }

    final policy = UpdatePolicy.values.asNameMap()[platform.policy];
    if (policy == null) {
      throw FormatException('Unknown update policy "${platform.policy}"');
    }

    final storeUrl = Uri.tryParse(platform.storeUrl);
    if (storeUrl == null || storeUrl.scheme != 'https' || !appStoreAllowedHosts.contains(storeUrl.host)) {
      // Sin la URL completa en el mensaje: acaba en logs.
      throw FormatException('Store URL rejected (host: ${storeUrl?.host ?? '?'})');
    }

    return AppUpdateManifest(
      latestVersion: AppVersion.parse(platform.latestVersion),
      minVersion: AppVersion.parse(platform.minVersion),
      policy: policy,
      storeUrl: storeUrl,
    );
  }
}
