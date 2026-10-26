import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';

import 'package:meta/meta.dart';

/// Lo que el servidor de versiones decide para la versión instalada: qué
/// pedir al ciudadano, a qué versión actualizar y, opcionalmente, con qué
/// texto.
///
/// La decisión llega tal cual del servidor; el use case comprueba que sea
/// coherente con lo instalado antes de mostrar nada.
@immutable
final class AppUpdateDecision {
  const AppUpdateDecision({
    required this.policy,
    this.publishedVersion,
    this.message,
  });

  /// Nada que avisar.
  const AppUpdateDecision.none() : this(policy: UpdatePolicy.none);

  final UpdatePolicy policy;

  /// Versión a la que se invita a actualizar. El contrato la exige cuando
  /// [policy] no es [UpdatePolicy.none].
  final AppVersion? publishedVersion;

  /// Texto curado del servidor que sustituye la explicación por defecto.
  final String? message;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AppUpdateDecision && runtimeType == other.runtimeType && policy == other.policy && publishedVersion == other.publishedVersion && message == other.message;

  @override
  int get hashCode => Object.hash(policy, publishedVersion, message);

  @override
  String toString() => 'AppUpdateDecision(policy: ${policy.name}, published: $publishedVersion, message: ${message != null})';
}
