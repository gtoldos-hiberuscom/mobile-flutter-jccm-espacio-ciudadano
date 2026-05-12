import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config_provider.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';

/// DI composition for [AuthRepository].
final authRepositoryProvider = Provider<AuthRepository>((final ref) => AuthRepositoryImpl(
  config: ref.watch(appConfigProvider),
  dio: ref.watch(dioProvider),
));
