import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/api/play_in_app_update_api.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/play_manifest_mapper.dart';

/// Transporte de Android: la actualización disponible según Google Play
/// (plugin `in_app_update`), en espacio de `versionCode`.
///
/// No captura nada: si la app no viene de Play, no hay Play Services o Play no
/// contesta, se propaga y el use case lo convierte en «no bloquear». No
/// memoriza: cada vuelta de segundo plano vuelve a preguntar.
final class PlayAppUpdateRepositoryImpl implements AppUpdateRepository {
  const PlayAppUpdateRepositoryImpl({
    required final InstalledVersionRepository installed,
    final CheckPlayUpdate checkForUpdate = PlayInAppUpdateApi.checkForUpdate,
  }) : _installed = installed,
       _checkForUpdate = checkForUpdate;

  final InstalledVersionRepository _installed;
  final CheckPlayUpdate _checkForUpdate;

  @override
  Future<AppUpdateManifest> fetchManifest() async {
    final installed = await _installed.installedVersion();
    final packageName = await _installed.applicationId();
    final info = await _checkForUpdate();
    return PlayManifestMapper.fromDto(info, installed: installed, packageName: packageName);
  }
}
