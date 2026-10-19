import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level_required.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/authentication_level_provider.dart';

/// Corta la consulta cuando la sesión no alcanza [minimum].
///
/// **Esto no protege el dato: lo protege el backend.** Existe para darle al
/// ciudadano un camino utilizable —saber por qué no ve sus citas y poder
/// arreglarlo— en vez de un error de servicio. Si el gateway dejara de aplicar
/// el nivel, esta comprobación no sería la que lo sostiene.
///
/// Comprueba **antes** de invocar [request], así que con nivel insuficiente no
/// llega a salir ninguna petición. Ése es el motivo de que la app pueda
/// distinguir «falta nivel» de «falta cláusula» sin depender de que el sobre de
/// la fachada los distinga: el de nivel se decide aquí, en local.
///
/// Usa `watch` y no `read` a propósito: es lo que hace que, al elevar el nivel,
/// el provider que envuelve se reconstruya solo y la consulta se reintente sin
/// necesidad de invalidar nada a mano.
Future<T> withAuthenticationLevelGuard<T>(
  final Ref ref, {
  required final AuthenticationLevel minimum,
  required final Future<T> Function() request,
}) async {
  final reading = ref.watch(authenticationLevelProvider);
  if (!reading.meets(minimum)) {
    throw AuthenticationLevelRequired(current: reading, minimum: minimum);
  }
  return request();
}
