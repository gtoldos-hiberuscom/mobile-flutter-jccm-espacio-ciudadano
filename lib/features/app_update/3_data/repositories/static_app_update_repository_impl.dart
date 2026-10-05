import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/app_update_manifest_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/app_update_manifest_mapper.dart';

/// Transporte **temporal**: sirve un manifiesto JSON fijado en código.
///
/// Pasa por el mismo DTO y mapper que usará el transporte definitivo (URL,
/// string remoto, Firebase Remote Config…), así que cuando se decida solo hay
/// que sustituir esta clase en `appUpdateRepositoryProvider`.
final class StaticAppUpdateRepositoryImpl implements AppUpdateRepository {
  const StaticAppUpdateRepositoryImpl({
    required final String manifestJson,
    required final String platformKey,
  }) : _manifestJson = manifestJson,
       _platformKey = platformKey;

  final String _manifestJson;
  final String _platformKey;

  @override
  Future<AppUpdateManifest> fetchManifest() async {
    final dto = AppUpdateManifestDto.fromJsonString(_manifestJson);
    return AppUpdateManifestMapper.fromDto(dto, platformKey: _platformKey);
  }
}
