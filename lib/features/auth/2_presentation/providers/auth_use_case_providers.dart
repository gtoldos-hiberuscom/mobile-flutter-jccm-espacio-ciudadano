import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';

/// DI composition for [LoginUseCase].
///
/// The use case writes the access token to [SecureStorage] so it is
/// available to the network auth interceptor for subsequent requests.
/// Notifier updates (TokenResponseNotifier, JwtClaimsNotifier) are the
/// responsibility of the caller (e.g. LandingNotifier) after inspecting the
/// [LoginResult].
final loginUseCaseProvider = Provider<LoginUseCase>((final ref) => LoginUseCase(
  ref.watch(authRepositoryProvider),
  ref.watch(secureStorageProvider),
));

/// DI composition for [LogoutUseCase].
final logoutUseCaseProvider = Provider<LogoutUseCase>((final ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));
