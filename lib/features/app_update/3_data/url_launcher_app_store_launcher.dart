import 'package:jccm_espacio_ciudadano/core/logger/logger.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/app_store_launcher.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/1_domain/repositories/installed_version_repository.dart';
import 'package:url_launcher/url_launcher.dart';

/// Firma de `launchUrl` de `package:url_launcher`, inyectable para los tests.
typedef StoreLaunchUrlFn = Future<bool> Function(Uri url, {LaunchMode mode});

/// Ficha de la app en la tienda de [platform]: Google Play por el id del
/// paquete, App Store por el id numérico de App Store Connect.
Uri appStorePageUrl({
  required final StorePlatform platform,
  required final String applicationId,
  required final String appStoreId,
}) => switch (platform) {
  StorePlatform.android => Uri.https('play.google.com', '/store/apps/details', {'id': applicationId}),
  StorePlatform.ios => Uri.https('apps.apple.com', '/es/app/id$appStoreId'),
};

/// Abre la tienda con `url_launcher`. La URL se construye en local con
/// [appStorePageUrl]; no llega de fuera.
final class UrlLauncherAppStoreLauncher implements AppStoreLauncher {
  const UrlLauncherAppStoreLauncher({
    required final StorePlatform? platform,
    required final InstalledVersionRepository installed,
    required final String appStoreId,
    final StoreLaunchUrlFn launchUrlFn = launchUrl,
  }) : _platform = platform,
       _installed = installed,
       _appStoreId = appStoreId,
       _launchUrlFn = launchUrlFn;

  final StorePlatform? _platform;
  final InstalledVersionRepository _installed;
  final String _appStoreId;
  final StoreLaunchUrlFn _launchUrlFn;

  @override
  Future<bool> openStore() async {
    final platform = _platform;
    if (platform == null) {
      logger.w('[app_update] no hay tienda para esta plataforma');
      return false;
    }
    try {
      final url = appStorePageUrl(platform: platform, applicationId: await _installed.applicationId(), appStoreId: _appStoreId);
      final accepted = await _launchUrlFn(url, mode: LaunchMode.externalApplication);
      if (!accepted) {
        logger.w('[app_update] la plataforma no abrió la tienda (host: ${url.host})');
      }
      return accepted;
    } on Object catch (error, stackTrace) {
      logger.e('[app_update] error al abrir la tienda', error: error, stackTrace: stackTrace);
      return false;
    }
  }
}
