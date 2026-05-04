import 'package:jccm_espacio_ciudadano/features/auth/1_domain/login_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/logout_use_case.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_session_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_use_case_providers.g.dart';

@riverpod
LoginUseCase loginUseCase(final Ref ref) => LoginUseCase(
      ref.watch(authRepositoryProvider),
      ref.watch(authSessionRepositoryProvider),
    );

@riverpod
LogoutUseCase logoutUseCase(final Ref ref) => LogoutUseCase(
      ref.watch(authRepositoryProvider),
      ref.watch(authSessionRepositoryProvider),
    );
