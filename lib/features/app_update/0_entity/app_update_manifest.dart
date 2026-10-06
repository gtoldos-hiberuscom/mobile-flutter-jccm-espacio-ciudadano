import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';

import 'package:meta/meta.dart';

/// Lo que el repositorio externo publica sobre la app **para la plataforma en
/// la que corre** (Android o iOS): la última versión, la mínima soportada, la
/// política para quien esté entre ambas y dónde actualizar.
///
/// Regla de resolución (en `CheckAppUpdateUsecase`):
/// instalada < [minVersion] → forzada; instalada < [latestVersion] → [policy];
/// si no, nada.
@immutable
final class AppUpdateManifest {
  const AppUpdateManifest({
    required this.latestVersion,
    required this.minVersion,
    required this.policy,
    required this.storeUrl,
    this.displayVersion,
  });

  /// Última versión publicada en la tienda.
  final AppVersion latestVersion;

  /// Versión mínima que sigue teniendo soporte; por debajo se fuerza actualizar.
  final AppVersion minVersion;

  /// Política para quien está entre [minVersion] y [latestVersion].
  final UpdatePolicy policy;

  /// Ficha de la app en la tienda (Play Store / App Store). Siempre `https`.
  final Uri storeUrl;

  /// Versión tal y como la ve el ciudadano (`x.y.z` de marketing). `null`
  /// cuando [latestVersion] es un `versionCode` y no debe enseñarse.
  final String? displayVersion;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AppUpdateManifest && runtimeType == other.runtimeType && latestVersion == other.latestVersion && minVersion == other.minVersion && policy == other.policy && storeUrl == other.storeUrl && displayVersion == other.displayVersion;

  @override
  int get hashCode => Object.hash(latestVersion, minVersion, policy, storeUrl, displayVersion);

  @override
  String toString() => 'AppUpdateManifest(latest: $latestVersion, min: $minVersion, policy: ${policy.name}, store: ${storeUrl.host}, display: $displayVersion)';
}
