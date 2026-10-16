import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/demo/demo_session.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';

/// `true` mientras la sesión en curso es la del modo demostración.
///
/// Derivado de los claims, no guardado aparte (ver [DemoSession]). Quien lo
/// observa —`authRepositoryProvider`, `dioProvider`— cambia de implementación
/// en las dos transiciones (entrar y cerrar sesión) y en ninguna otra: en los
/// logins reales el valor sigue siendo `false` y `Provider` no notifica.
final demoModeProvider = Provider<bool>((final ref) => DemoSession.isDemo(ref.watch(jwtClaimsProvider)));
