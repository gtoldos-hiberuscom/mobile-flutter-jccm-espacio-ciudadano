import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';

abstract interface class SupportRepository {
  /// Envía la incidencia. Con [idAgente] (sesión iniciada) se usa la ruta
  /// autenticada `/ciudadanos/{idAgente}/soporte`; sin él, la ruta pública.
  Future<void> submitSupportRequest(final SupportRequest request, {final String? idAgente});
}
