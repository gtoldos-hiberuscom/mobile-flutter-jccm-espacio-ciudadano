import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/repositories/consent_repository_impl.dart';

/// DI composition root for [ConsentRepository].
///
/// Only `2_presentation/providers/` may import `3_data/` — this file is the
/// single point that wires the concrete implementation to its domain interface.
final consentRepositoryProvider = Provider<ConsentRepository>((final ref) {
  final storage = ref.watch(appStorageProvider);
  return ConsentRepositoryImpl(storage);
});
