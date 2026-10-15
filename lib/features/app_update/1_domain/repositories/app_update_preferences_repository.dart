import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';

/// Memoria local de la decisión del ciudadano sobre actualizaciones
/// recomendadas: la última versión que descartó con «Ahora no».
abstract interface class AppUpdatePreferencesRepository {
  /// `null` si nunca descartó ninguna (o lo guardado no es una versión válida).
  Future<AppVersion?> readIgnoredVersion();

  Future<void> saveIgnoredVersion(final AppVersion version);
}
