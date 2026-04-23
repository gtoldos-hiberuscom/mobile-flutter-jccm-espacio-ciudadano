import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_repository.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/3_data/agenda_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'agenda_repository_provider.g.dart';

/// DI composition for [AgendaRepository].
///
/// Not kept alive on purpose: the agenda is expected to refresh whenever
/// the user navigates back into the agenda surface (canon §16).
@riverpod
AgendaRepository agendaRepository(final Ref ref) =>
    const AgendaRepositoryImpl();
