import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/network/api_client_provider.dart';
import 'package:jccm_espacio_ciudadano/features/auth/0_entity/jwt_claims.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/providers/jwt_claims_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/health_appointment.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/1_domain/repositories/my_data_health_repository.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/3_data/my_data_health_repository_impl.dart';

final myDataHealthRepositoryProvider = Provider<MyDataHealthRepository>((final ref) {
  return MyDataHealthRepositoryImpl(dio: ref.watch(dioProvider));
});

final class MyDataHealthState {
  const MyDataHealthState({
    required this.cip,
    required this.appointments,
  });

  final String? cip;
  final List<HealthAppointment> appointments;
}

final myDataHealthProvider = FutureProvider.autoDispose.family<MyDataHealthState, HealthAppointmentFilter>((final ref, final filter) async {
  final documentNumber = _documentNumber(ref.watch(jwtClaimsProvider));
  if (documentNumber == null) {
    throw StateError('No se ha encontrado el documento del paciente.');
  }

  final repository = ref.watch(myDataHealthRepositoryProvider);
  final results = await Future.wait<Object?>([
    repository.loadCip(documentNumber: documentNumber),
    repository.loadAppointments(
      documentNumber: documentNumber,
      filter: filter,
    ),
  ]);

  return MyDataHealthState(
    cip: results[0] as String?,
    appointments: results[1]! as List<HealthAppointment>,
  );
});

String? _documentNumber(final JwtClaims? claims) {
  final candidates = [
    claims?.personIdentifier,
    claims?.preferredUsername,
    claims?.sub,
  ];
  for (final candidate in candidates) {
    final normalized = candidate?.trim();
    if (normalized != null && normalized.isNotEmpty) {
      return normalized;
    }
  }
  return null;
}
