import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';

import 'package:meta/meta.dart';

/// Lo que el aviso de actualización necesita mostrar: qué se pide, a qué
/// versión y, si el servidor lo manda, con qué texto.
///
/// Solo existe cuando hay algo que avisar: [policy] nunca es
/// [UpdatePolicy.none].
@immutable
final class AppUpdateInfo {
  const AppUpdateInfo({
    required this.policy,
    required this.latestVersion,
    this.message,
  }) : assert(policy != UpdatePolicy.none, 'AppUpdateInfo only exists when there is something to notify');

  final UpdatePolicy policy;

  /// Versión a la que se invita a actualizar; se enseña en el aviso.
  final AppVersion latestVersion;

  /// Texto del servidor que sustituye la explicación por defecto; `null` →
  /// el aviso usa su texto propio.
  final String? message;

  /// `true` cuando el aviso no se puede descartar.
  bool get isForced => policy == UpdatePolicy.forced;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AppUpdateInfo && runtimeType == other.runtimeType && policy == other.policy && latestVersion == other.latestVersion && message == other.message;

  @override
  int get hashCode => Object.hash(policy, latestVersion, message);

  @override
  String toString() => 'AppUpdateInfo(policy: ${policy.name}, latest: $latestVersion, message: ${message != null})';
}
