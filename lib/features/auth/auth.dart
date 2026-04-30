// Entity exports
export 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_failure.dart';
export 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session.dart';
export 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_session_state.dart';
export 'package:jccm_espacio_ciudadano/features/auth/0_entity/auth_user.dart';
// Domain exports
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_notifier.dart';
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
export 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
// Data provider exports (repository + use-case providers only — DTOs and datasource are internal)
export 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_provider.dart';
export 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_use_case_providers.dart';
export 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_auth_remote_datasource_provider.dart';
