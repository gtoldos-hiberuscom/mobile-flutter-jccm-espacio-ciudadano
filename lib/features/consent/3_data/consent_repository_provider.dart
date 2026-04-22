import 'package:jccm_espacio_ciudadano/core/storage/secure_storage.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/consent_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'consent_repository_provider.g.dart';

/// Provides the singleton [ConsentRepository] implementation.
///
/// Kept alive for the full app lifetime so the consent lifecycle is always
/// available without re-creating the notifier on navigation changes.
@Riverpod(keepAlive: true)
ConsentRepository consentRepository(final Ref ref) {
  final storage = ref.watch(secureStorageProvider);
  return ConsentRepositoryImpl(storage);
}
