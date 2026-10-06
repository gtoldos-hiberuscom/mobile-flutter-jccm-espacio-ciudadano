import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';

/// Lo que el dispositivo sabe de la app instalada.
abstract interface class InstalledVersionRepository {
  /// Versión instalada, en el espacio de la tienda de la plataforma (versión
  /// de marketing en iOS, `0.0.versionCode` en Android).
  Future<AppVersion> installedVersion();

  /// Id de aplicación (`bundleId` en iOS, `applicationId` en Android) con el
  /// que se localiza la ficha en la tienda.
  Future<String> applicationId();
}
