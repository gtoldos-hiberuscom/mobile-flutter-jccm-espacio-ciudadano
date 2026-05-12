import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/load_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/reset_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/1_domain/usecases/save_life_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/personalization/2_presentation/providers/life_events_repository_provider.dart';

/// DI composition for [LoadLifeEventsUsecase].
final loadLifeEventsUsecaseProvider = Provider<LoadLifeEventsUsecase>(
  (final ref) => LoadLifeEventsUsecase(ref.watch(lifeEventsRepositoryProvider)),
);

/// DI composition for [SaveLifeEventsUsecase].
final saveLifeEventsUsecaseProvider = Provider<SaveLifeEventsUsecase>(
  (final ref) => SaveLifeEventsUsecase(ref.watch(lifeEventsRepositoryProvider)),
);

/// DI composition for [ResetLifeEventsUsecase].
final resetLifeEventsUsecaseProvider = Provider<ResetLifeEventsUsecase>(
  (final ref) => ResetLifeEventsUsecase(ref.watch(lifeEventsRepositoryProvider)),
);
