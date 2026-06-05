import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/auth_repository_provider.dart';

/// DI composition for [LoginUseCase].
final loginUseCaseProvider = Provider<LoginUseCase>(
  (final ref) => LoginUseCase(
    ref.watch(authRepositoryProvider),
  ),
);

/// DI composition for [LogoutUseCase].
final logoutUseCaseProvider = Provider<LogoutUseCase>((final ref) => LogoutUseCase(ref.watch(authRepositoryProvider)));
