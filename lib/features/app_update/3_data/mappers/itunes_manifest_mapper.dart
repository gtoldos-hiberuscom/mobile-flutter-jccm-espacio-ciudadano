import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_update_manifest.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/dto/itunes_lookup_dto.dart';

/// Respuesta de iTunes → manifiesto. Único punto de validación del transporte
/// de App Store: cualquier dato que no cuadre lanza [FormatException] y el use
/// case lo convierte en «no bloquear».
///
/// App Store no tiene concepto de «versión mínima soportada» y, por decisión
/// del 06/10/2026, no se usan etiquetas en la descripción de la ficha para
/// suplirlo: este transporte **solo recomienda, nunca fuerza**
/// (`minVersion = 0.0.0`, `policy = recommended`).
final class ItunesManifestMapper {
  const ItunesManifestMapper._();

  static AppUpdateManifest fromDto(final ItunesLookupDto dto, {required final String bundleId}) {
    if (dto.resultCount == 0 || dto.results.isEmpty) {
      // La app no está publicada en ese storefront (o aún no ha propagado).
      throw const FormatException('App Store lookup returned no results for the bundle id');
    }
    final result = dto.results.first;

    final resultBundleId = result.bundleId;
    if (resultBundleId != null && resultBundleId.toLowerCase() != bundleId.toLowerCase()) {
      throw const FormatException('App Store lookup returned a different app');
    }

    final latestVersion = AppVersion.parse(result.version);

    final storeUrl = Uri.tryParse(result.trackViewUrl);
    if (storeUrl == null || storeUrl.scheme != 'https' || !appStoreAllowedHosts.contains(storeUrl.host)) {
      // Sin la URL completa en el mensaje: acaba en logs.
      throw FormatException('Store URL rejected (host: ${storeUrl?.host ?? '?'})');
    }

    return AppUpdateManifest(
      latestVersion: latestVersion,
      minVersion: const AppVersion(0, 0, 0),
      policy: UpdatePolicy.recommended,
      storeUrl: storeUrl,
      displayVersion: latestVersion.toString(),
    );
  }
}
