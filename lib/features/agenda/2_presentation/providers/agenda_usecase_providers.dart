import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/load_agenda_appointments_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/refresh_agenda_events_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_repository_provider.dart';

final loadAgendaAppointmentsUsecaseProvider = Provider<LoadAgendaAppointmentsUsecase>(
  (final ref) => LoadAgendaAppointmentsUsecase(ref.watch(agendaRepositoryProvider)),
);

final refreshAgendaEventsUsecaseProvider = Provider<RefreshAgendaEventsUsecase>(
  (final ref) => RefreshAgendaEventsUsecase(ref.watch(agendaRepositoryProvider)),
);
