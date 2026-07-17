import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/usecases/load_agenda_appointments_usecase.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/providers/agenda_usecase_providers.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';

final class AgendaAppointmentsState {
  const AgendaAppointmentsState({
    required this.appointments,
    required this.updatedAt,
    required this.hasJccmAuthorization,
  });

  final List<AgendaAppointment> appointments;
  final DateTime updatedAt;
  final bool hasJccmAuthorization;
}

final agendaAppointmentsProvider = FutureProvider.autoDispose<AgendaAppointmentsState>((final ref) async {
  final hasJccmAuthorization = await ref.watch(jccmDataAuthorizationProvider.future);
  if (!hasJccmAuthorization) {
    return AgendaAppointmentsState(
      appointments: const [],
      updatedAt: DateTime.now(),
      hasJccmAuthorization: false,
    );
  }

  final claims = ref.watch(jwtClaimsProvider);
  final documentNumber = claims?.personIdentifier ?? claims?.preferredUsername ?? claims?.idAgente;
  if (documentNumber == null || documentNumber.trim().isEmpty) {
    throw StateError('No se ha encontrado el documento del usuario.');
  }

  final result = await ref
      .read(loadAgendaAppointmentsUsecaseProvider)
      .execute(
        documentNumber: documentNumber.trim(),
        agentId: claims?.idAgente?.trim(),
      );

  return switch (result) {
    LoadAgendaAppointmentsSuccess(:final appointments) => AgendaAppointmentsState(
      appointments: appointments,
      updatedAt: DateTime.now(),
      hasJccmAuthorization: true,
    ),
    LoadAgendaAppointmentsFailed(:final message) => throw Exception(message),
  };
});
