// Entity exports
export 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
export 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
// Domain exports
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
export 'package:jccm_espacio_ciudadano/features/auth/di/auth_session_notifier.dart';
// Presentation exports (session notifier + derived user provider + DI providers)
export 'package:jccm_espacio_ciudadano/features/auth/di/auth_use_case_providers.dart';
