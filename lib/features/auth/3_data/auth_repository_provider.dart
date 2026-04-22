import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/1_domain/auth_repository.dart';
import 'package:jccm_espacio_ciudadano/features/auth/3_data/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository_provider.g.dart';

/// Provides the singleton [AuthRepository] implementation.
///
/// Kept alive for the full app lifetime so the auth lifecycle is always
/// available without re-creating the notifier on navigation changes.
@Riverpod(keepAlive: true)
AuthRepository authRepository(final Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return AuthRepositoryImpl(storage);
}
