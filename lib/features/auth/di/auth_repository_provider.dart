import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

const List<String> authDefaultScopes = ['openid'];

/// DI composition for [AuthRepository].
@riverpod
AuthRepository authRepository(final Ref ref) => AuthRepositoryImpl(
  config: ref.watch(appConfigProvider),
  dio: ref.watch(dioProvider),
);
