import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/core/storage/app_storage.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/consent/1_domain/repositories/consent_repository.dart';
import 'package:jccm_espacio_ciudadano/features/consent/3_data/repositories/consent_repository_impl.dart';

/// DI composition root for [ConsentRepository].
///
/// Only `2_presentation/providers/` may import `3_data/` — this file is the
/// single point that wires the concrete implementation to its domain interface.
final consentRepositoryProvider = Provider<ConsentRepository>((final ref) {
  final storage = ref.watch(appStorageProvider);
  final dio = ref.watch(dioProvider);
  final agentId = ref.watch(jwtClaimsProvider)?.idAgente;
  return ConsentRepositoryImpl(storage: storage, dio: dio, agentId: agentId);
});
