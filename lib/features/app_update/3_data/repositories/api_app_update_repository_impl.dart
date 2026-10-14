import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/api/app_version_api.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_decision_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/app_update_decision_mapper.dart';

/// Decisión del servidor de versiones para la plataforma en la que corre la
/// app.
///
/// No captura nada: fallos de red o respuesta inválida se propagan y el use
/// case los convierte en «no bloquear». No memoriza: cada vuelta de segundo
/// plano vuelve a preguntar, para que un forzado surta efecto enseguida.
final class ApiAppUpdateRepositoryImpl implements AppUpdateRepository {
  const ApiAppUpdateRepositoryImpl({
    required final AppVersionApi api,
    required final StorePlatform platform,
  }) : _api = api,
       _platform = platform;

  final AppVersionApi _api;
  final StorePlatform _platform;

  @override
  Future<AppUpdateDecision> fetchDecision({
    required final String applicationId,
    required final AppVersion installedVersion,
  }) async {
    final data = await _api.checkUpdate(
      platform: platformParam(_platform),
      applicationId: applicationId,
      version: installedVersion.toString(),
    );
    return AppUpdateDecisionMapper.fromDto(AppUpdateDecisionDto.fromResponse(data));
  }

  /// Valor del parámetro `plataforma` del contrato.
  static String platformParam(final StorePlatform platform) => switch (platform) {
    StorePlatform.android => 'ANDROID',
    StorePlatform.ios => 'IOS',
  };
}
