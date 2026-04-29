import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/cip_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/cip_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cip_repository_provider.g.dart';

/// DI composition for [CipRepository] (STORY-31).
///
/// Co-located in the agenda data layer per the TASK-71 surface decision
/// (CIP_REUSE — salud owns the CIP). Not kept alive on purpose: the
/// CIP snapshot should refresh on every visit to the agenda or salud
/// home entry (canon §16).
@riverpod
CipRepository cipRepository(final Ref ref) => const CipRepositoryImpl();
