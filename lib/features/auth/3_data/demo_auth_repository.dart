import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';

/// [AuthRepository] del modo demostración: ni Cl@ve, ni Cerbero, ni red.
///
/// La sesión demo arranca con `AuthSessionController.startInMemory` y no por
/// [login]; este repositorio existe para lo que pase **después**, cuando los
/// claims ya son demo y `authRepositoryProvider` apunta aquí: una renovación
/// (que con la caducidad del token demo no debería llegar), una elevación de
/// nivel —[login], que entrega directamente el nivel alto— y, sobre todo, el cierre de sesión, que no debe abrir ningún
/// navegador ni revocar nada en Keycloak.
final class DemoAuthRepository implements AuthRepository {
  const DemoAuthRepository();

  @override
  Future<TokenResponse> login({
    final List<String> scopes = authDefaultScopes,
    final String? loginHint,
    final Map<String, String> extraParameters = const <String, String>{},
  }) async => DemoSession.tokenResponse(level: DemoSession.elevatedLevel);

  /// Con la caducidad del token demo no debería llegar nunca; si llegara,
  /// conserva el nivel elevado para no deshacer una verificación ya hecha.
  @override
  Future<TokenResponse> refreshToken({
    required final String refreshToken,
    final List<String> scopes = authDefaultScopes,
  }) async => DemoSession.tokenResponse(level: DemoSession.elevatedLevel);

  @override
  Future<void> revokeOfflineSession({required final String refreshToken}) async {}

  @override
  Future<void> logout({
    required final String idToken,
    final String? postLogoutRedirectUri,
  }) async {}
}
