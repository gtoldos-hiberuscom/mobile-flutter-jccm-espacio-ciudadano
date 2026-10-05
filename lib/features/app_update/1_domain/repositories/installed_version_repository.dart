import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';

/// Versión de la app que tiene instalada el dispositivo.
abstract interface class InstalledVersionRepository {
  Future<AppVersion> installedVersion();
}
