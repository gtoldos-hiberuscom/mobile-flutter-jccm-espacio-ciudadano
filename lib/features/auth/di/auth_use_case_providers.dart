import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/network_interceptors.dart' show AuthInterceptor;
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/token_response_notifier.dart';

/// DI composition for [LoginUseCase].
///
/// Injects the notifiers so the use case can persist the session and user
/// in memory. Also passes the SecureStorage so the access token is written
/// there, making it available to [AuthInterceptor] for subsequent requests.
final loginUseCaseProvider = Provider<LoginUseCase>((final ref) => LoginUseCase(
  ref.watch(authRepositoryProvider),
  ref.watch(tokenResponseProvider.notifier),
  ref.watch(jwtClaimsProvider.notifier),
  ref.watch(secureStorageProvider),
));

/// DI composition for [LogoutUseCase].
final logoutUseCaseProvider = Provider<LogoutUseCase>((final ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));
