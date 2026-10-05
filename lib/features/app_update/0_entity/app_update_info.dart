import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';

import 'package:meta/meta.dart';

/// Lo que el aviso de actualización necesita mostrar: qué se pide, qué versión
/// hay publicada y dónde conseguirla.
///
/// Solo existe cuando hay algo que avisar: [policy] nunca es
/// [UpdatePolicy.none].
@immutable
final class AppUpdateInfo {
  const AppUpdateInfo({
    required this.policy,
    required this.latestVersion,
    required this.storeUrl,
  }) : assert(policy != UpdatePolicy.none, 'AppUpdateInfo only exists when there is something to notify');

  final UpdatePolicy policy;
  final AppVersion latestVersion;
  final Uri storeUrl;

  /// `true` cuando el aviso no se puede descartar.
  bool get isForced => policy == UpdatePolicy.forced;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AppUpdateInfo && runtimeType == other.runtimeType && policy == other.policy && latestVersion == other.latestVersion && storeUrl == other.storeUrl;

  @override
  int get hashCode => Object.hash(policy, latestVersion, storeUrl);

  @override
  String toString() => 'AppUpdateInfo(policy: ${policy.name}, latest: $latestVersion, store: ${storeUrl.host})';
}
