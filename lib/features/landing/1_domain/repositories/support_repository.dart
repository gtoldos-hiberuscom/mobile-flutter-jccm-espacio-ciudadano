import 'package:jccm_espacio_ciudadano/features/landing/0_entity/support_request.dart';

abstract interface class SupportRepository {
  Future<void> submitSupportRequest(final SupportRequest request);
}
