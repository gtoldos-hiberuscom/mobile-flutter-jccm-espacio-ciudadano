import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_session_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/auth/di/auth_user_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_use_case_providers.g.dart';

/// DI composition for [LoginUseCase].
///
/// Injects the notifiers so the use case can persist the session and user
/// in memory. Also passes the SecureStorage so the access token is written
/// there, making it available to [AuthInterceptor] for subsequent requests.
@riverpod
LoginUseCase loginUseCase(final Ref ref) => LoginUseCase(
  ref.watch(authRepositoryProvider),
  ref.watch(authSessionProvider.notifier),
  ref.watch(authUserProvider.notifier),
  ref.watch(secureStorageProvider),
);

/// DI composition for [LogoutUseCase].
@riverpod
LogoutUseCase logoutUseCase(final Ref ref) => LogoutUseCase(ref.watch(authRepositoryProvider));
