import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_decision.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_decision_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/app_update_decision_mapper.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/app_update_mock_scenario.dart';

/// Responde siempre lo mismo, sin red: la respuesta fija de un
/// [AppUpdateMockScenario], que pasa por el mismo DTO y mapper que la del
/// servidor. Para desarrollo y QA mientras el servidor no existe.
final class MockAppUpdateRepositoryImpl implements AppUpdateRepository {
  const MockAppUpdateRepositoryImpl(this._scenario);

  final AppUpdateMockScenario _scenario;

  @override
  Future<AppUpdateDecision> fetchDecision({
    required final String applicationId,
    required final AppVersion installedVersion,
  }) async => AppUpdateDecisionMapper.fromDto(AppUpdateDecisionDto.fromJsonString(_scenario.responseJson));
}
