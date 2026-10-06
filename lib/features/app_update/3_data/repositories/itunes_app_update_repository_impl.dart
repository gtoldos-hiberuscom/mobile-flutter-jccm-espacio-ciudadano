import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/app_update_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/api/itunes_lookup_api.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/itunes_lookup_dto.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/mappers/itunes_manifest_mapper.dart';

/// Transporte de iOS: la versión publicada en App Store por la búsqueda de
/// iTunes, localizada por el bundle id de la app instalada.
///
/// No captura nada: fallos de red, respuesta inválida o app no publicada se
/// propagan y el use case los convierte en «no bloquear». No memoriza: cada
/// vuelta de segundo plano vuelve a preguntar. Ojo: iTunes va por CDN y una
/// versión recién publicada puede tardar horas en aparecer.
final class ItunesAppUpdateRepositoryImpl implements AppUpdateRepository {
  const ItunesAppUpdateRepositoryImpl({
    required final ItunesLookupApi api,
    required final InstalledVersionRepository installed,
    final String country = 'es',
  }) : _api = api,
       _installed = installed,
       _country = country;

  final ItunesLookupApi _api;
  final InstalledVersionRepository _installed;

  /// Storefront en el que está publicada la app.
  final String _country;

  @override
  Future<AppUpdateManifest> fetchManifest() async {
    final bundleId = await _installed.applicationId();
    final body = await _api.lookup(bundleId: bundleId, country: _country);
    return ItunesManifestMapper.fromDto(ItunesLookupDto.fromJsonString(body), bundleId: bundleId);
  }
}
