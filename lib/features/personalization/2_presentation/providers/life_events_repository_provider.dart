import 'package:espacio_ciudadano_api/espacio_ciudadano_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_impl.dart';

/// DI composition for [LifeEventsRepository].
///
/// Only `2_presentation/providers/` may import `3_data/` — this file is the
/// single composition root that wires the API client into the concrete impl.
final lifeEventsRepositoryProvider = Provider<LifeEventsRepository>((final ref) {
  final dio = ref.watch(dioProvider);
  return LifeEventsRepositoryImpl(
    api: HechosVitalesApi(dio, standardSerializers),
  );
});
