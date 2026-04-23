import 'package:jccm_espacio_ciudadano/features/state_affairs/1_domain/state_affairs_repository.dart';
import 'package:jccm_espacio_ciudadano/features/state_affairs/3_data/state_affairs_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'state_affairs_repository_provider.g.dart';

/// DI composition for [StateAffairsRepository].
///
/// Not kept alive on purpose — the snapshot is expected to refresh
/// whenever the user re-enters the landing (canon §16).
@riverpod
StateAffairsRepository stateAffairsRepository(final Ref ref) =>
    const StateAffairsRepositoryImpl();
