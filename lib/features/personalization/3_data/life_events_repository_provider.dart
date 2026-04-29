import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/life_events_repository.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/3_data/life_events_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'life_events_repository_provider.g.dart';

/// DI composition for [LifeEventsRepository].
@riverpod
LifeEventsRepository lifeEventsRepository(final Ref ref) => const LifeEventsRepositoryImpl();
