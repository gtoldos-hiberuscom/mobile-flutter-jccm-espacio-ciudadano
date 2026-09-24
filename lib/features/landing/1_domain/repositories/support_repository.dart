import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';

abstract interface class SupportRepository {
  /// Envía la incidencia. Con [idAgente] (sesión iniciada) se usa
  /// `/api/v1/soporte`; sin él, la ruta pública `/ciudadanos/soporte`.
  Future<void> submitSupportRequest(final SupportRequest request, {final String? idAgente});
}
