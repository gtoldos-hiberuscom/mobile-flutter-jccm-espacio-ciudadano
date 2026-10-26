import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';

/// Lo que el dispositivo sabe de la app instalada.
abstract interface class InstalledVersionRepository {
  /// Versión de marketing instalada (`x.y.z`), sin número de build.
  Future<AppVersion> installedVersion();

  /// Id de aplicación: `applicationId` en Android, `bundleId` en iOS.
  Future<String> applicationId();
}
