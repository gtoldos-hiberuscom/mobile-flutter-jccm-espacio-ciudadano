import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

/// Firma de `launchUrl` de `package:url_launcher`, inyectable para los tests.
typedef StoreLaunchUrlFn = Future<bool> Function(Uri url, {LaunchMode mode});

/// Abre la tienda con `url_launcher`.
///
/// No reutiliza `UrlLauncherExternalLinkLauncher` porque aquel exige que el
/// enlace esté en el catálogo de enlaces externos, y la URL de la tienda llega
/// en el manifiesto remoto. El endurecimiento es el mismo: solo `https` y solo
/// hosts de [appStoreAllowedHosts]; la URL completa no se registra nunca.
final class UrlLauncherAppStoreLauncher implements AppStoreLauncher {
  const UrlLauncherAppStoreLauncher({final StoreLaunchUrlFn launchUrlFn = launchUrl}) : _launchUrlFn = launchUrlFn;

  final StoreLaunchUrlFn _launchUrlFn;

  @override
  Future<bool> openStore(final Uri storeUrl) async {
    if (storeUrl.scheme != 'https' || !appStoreAllowedHosts.contains(storeUrl.host)) {
      logger.w('[app_update] URL de tienda rechazada (host: ${storeUrl.host})');
      return false;
    }
    try {
      final accepted = await _launchUrlFn(storeUrl, mode: LaunchMode.externalApplication);
      if (!accepted) {
        logger.w('[app_update] la plataforma no abrió la tienda (host: ${storeUrl.host})');
      }
      return accepted;
    } on Object catch (error, stackTrace) {
      logger.e('[app_update] error al abrir la tienda (host: ${storeUrl.host})', error: error, stackTrace: stackTrace);
      return false;
    }
  }
}
