import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/repositories/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_impl.dart';

/// DI composition for [LifeEventsRepository].
///
/// Only `2_presentation/providers/` may import `3_data/` — this file is the
/// single composition root that wires the API client into the concrete impl.
final lifeEventsRepositoryProvider = Provider<LifeEventsRepository>((final ref) {
  final dio = ref.watch(dioProvider);
  final agentId = ref.watch(jwtClaimsProvider)?.idAgente;
  return LifeEventsRepositoryImpl(
    dio: dio,
    agentId: agentId,
  );
});
