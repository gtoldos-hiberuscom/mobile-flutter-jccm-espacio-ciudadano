import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';

/// La consulta exige un nivel de autenticación que la sesión actual no alcanza.
///
/// Espejo de `MyDataAuthorizationRequired`, pero para el otro eje: aquélla dice
/// que falta una cláusula, ésta que falta nivel. Son cosas distintas y el
/// ciudadano las arregla en sitios distintos —Preferencias frente a volver a
/// identificarse en Cl@ve—, así que no comparten tipo.
///
/// Lleva [current] para que la pantalla pueda distinguir «tu nivel es bajo» de
/// «no hemos sabido leer tu nivel», que se resuelven igual pero no se cuentan
/// igual.
final class AuthenticationLevelRequired implements Exception {
  const AuthenticationLevelRequired({
    required this.current,
    required this.minimum,
  });

  /// Lo que se pudo leer del token: conocido, desconocido o ausente.
  final AuthenticationLevelReading current;

  /// El nivel que exige la funcionalidad.
  final AuthenticationLevel minimum;

  @override
  String toString() => 'AuthenticationLevelRequired(current: $current, minimum: $minimum)';
}
