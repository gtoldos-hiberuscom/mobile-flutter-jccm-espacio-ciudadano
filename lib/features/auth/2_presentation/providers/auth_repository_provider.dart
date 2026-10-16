import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_mode_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/demo_auth_repository.dart';

/// DI composition for [AuthRepository].
///
/// En modo demostración (sesión con claims demo) la implementación es
/// [DemoAuthRepository]: cerrar sesión, renovar o elevar nivel no deben tocar
/// ni Cl@ve ni Keycloak. Los casos de uso y `authSessionControllerProvider`
/// observan este provider, así que el cambio les llega solo.
final authRepositoryProvider = Provider<AuthRepository>((final ref) {
  if (ref.watch(demoModeProvider)) {
    return const DemoAuthRepository();
  }
  final config = ref.watch(appConfigProvider);
  return AuthRepositoryImpl(config: config);
});
