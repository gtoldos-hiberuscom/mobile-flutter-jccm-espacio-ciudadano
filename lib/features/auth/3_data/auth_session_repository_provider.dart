import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_session_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_session_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_repository_provider.g.dart';

@Riverpod(keepAlive: true)
AuthSessionRepository authSessionRepository(final Ref ref) {
  return AuthSessionRepositoryImpl(ref.watch(secureStorageProvider));
}
