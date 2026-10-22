import 'package:jccm_espacio_ciudadano/features/auth/0_entity/authentication_level.dart';

/// Nivel de autenticación mínimo para abrir Mi Salud Digital desde la app.
///
/// Es el que pide el enlace a Cerbero (`scope=openid substantial`, JCCMEC-275).
/// Si la sesión no lo alcanza, Cerbero vuelve a pasar por Cl@ve sin
/// `ForceAuthn`, y Cl@ve identifica sola con lo último que recuerde el
/// navegador: comprobado en PRE, un ciudadano de Cl@ve Permanente entraba en la
/// salud del último certificado usado. Por eso se eleva antes en la app, que sí
/// fuerza el desafío y comprueba que sigue siendo la misma persona.
const AuthenticationLevel kDigitalHealthMinimumLevel = AuthenticationLevel.substantial;
