import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';

/// Donde no hay tienda (tests en escritorio, web): la comprobación falla y el
/// use case la convierte en «no bloquear».
final class UnsupportedPlatformAppUpdateRepository implements AppUpdateRepository {
  const UnsupportedPlatformAppUpdateRepository();

  @override
  Future<AppUpdateDecision> fetchDecision({
    required final String applicationId,
    required final AppVersion installedVersion,
  }) async => throw UnsupportedError('app_update: no store for this platform');
}
