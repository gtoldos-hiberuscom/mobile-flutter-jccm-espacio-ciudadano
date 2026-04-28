import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/clave_auth_remote_datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_provider.g.dart';

@riverpod
AuthRepository authRepository(final Ref ref) =>
    AuthRepositoryImpl(ref.watch(claveAuthRemoteDatasourceProvider));
