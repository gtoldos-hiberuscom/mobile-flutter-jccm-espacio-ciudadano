import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';

/// Fuente de verdad sobre qué versión de la app está publicada.
///
/// La implementación devuelve el manifiesto **ya resuelto para la plataforma
/// en la que corre** y lanza ante cualquier manifiesto inválido; el use case
/// convierte ese fallo en «no bloquear» (fail-open).
///
/// El transporte (URL, string remoto, Firebase Remote Config…) está por
/// decidir: hoy lo cubre `StaticAppUpdateRepositoryImpl` en `3_data/` y la
/// implementación definitiva sustituirá solo esa clase.
abstract interface class AppUpdateRepository {
  Future<AppUpdateManifest> fetchManifest();
}
