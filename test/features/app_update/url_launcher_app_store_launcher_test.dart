import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/store_platform.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/url_launcher_app_store_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'support/app_update_fakes.dart';

void main() {
  group('appStorePageUrl', () {
    test('Google Play por el id del paquete', () {
      final url = appStorePageUrl(platform: StorePlatform.android, applicationId: 'es.jccm.espaciociudadano', appStoreId: '6795089236');
      expect(url.toString(), 'https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano');
    });

    test('App Store por el id de App Store Connect', () {
      final url = appStorePageUrl(platform: StorePlatform.ios, applicationId: 'es.jccm.espaciociudadano', appStoreId: '6795089236');
      expect(url.toString(), 'https://apps.apple.com/es/app/id6795089236');
    });
  });

  group('UrlLauncherAppStoreLauncher', () {
    final installed = FakeInstalledVersionRepository(const AppVersion(1, 0, 0));

    UrlLauncherAppStoreLauncher build({
      required final StoreLaunchUrlFn launchUrlFn,
      final StorePlatform? platform = StorePlatform.android,
    }) => UrlLauncherAppStoreLauncher(platform: platform, installed: installed, appStoreId: '6795089236', launchUrlFn: launchUrlFn);

    test('abre la ficha de la plataforma en aplicación externa', () async {
      final launched = <(Uri, LaunchMode)>[];
      final launcher = build(
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async {
          launched.add((url, mode));
          return true;
        },
      );

      expect(await launcher.openStore(), isTrue);
      expect(launched.single.$1.host, 'play.google.com');
      expect(launched.single.$1.queryParameters['id'], 'es.jccm.espaciociudadano');
      expect(launched.single.$2, LaunchMode.externalApplication);
    });

    test('sin tienda no llega a la plataforma', () async {
      var calls = 0;
      final launcher = build(
        platform: null,
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async {
          calls++;
          return true;
        },
      );

      expect(await launcher.openStore(), isFalse);
      expect(calls, 0);
    });

    test('devuelve false si la plataforma no acepta la URL', () async {
      final launcher = build(launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async => false);
      expect(await launcher.openStore(), isFalse);
    });

    test('devuelve false si la plataforma lanza', () async {
      final launcher = build(launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async => throw StateError('boom'));
      expect(await launcher.openStore(), isFalse);
    });
  });
}
