import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/url_launcher_app_store_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  group('UrlLauncherAppStoreLauncher', () {
    test('abre una URL https de la tienda en aplicación externa', () async {
      final launched = <(Uri, LaunchMode)>[];
      final launcher = UrlLauncherAppStoreLauncher(
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async {
          launched.add((url, mode));
          return true;
        },
      );

      final ok = await launcher.openStore(Uri.parse('https://play.google.com/store/apps/details?id=es.jccm.espaciociudadano'));

      expect(ok, isTrue);
      expect(launched, hasLength(1));
      expect(launched.single.$1.host, 'play.google.com');
      expect(launched.single.$2, LaunchMode.externalApplication);
    });

    test('rechaza http sin llegar a la plataforma', () async {
      var calls = 0;
      final launcher = UrlLauncherAppStoreLauncher(
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async {
          calls++;
          return true;
        },
      );

      expect(await launcher.openStore(Uri.parse('http://play.google.com/store/apps/details?id=x')), isFalse);
      expect(calls, 0);
    });

    test('rechaza un host fuera de la lista blanca sin llegar a la plataforma', () async {
      var calls = 0;
      final launcher = UrlLauncherAppStoreLauncher(
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async {
          calls++;
          return true;
        },
      );

      expect(await launcher.openStore(Uri.parse('https://evil.example.com/app')), isFalse);
      expect(calls, 0);
    });

    test('devuelve false si la plataforma no acepta la URL', () async {
      final launcher = UrlLauncherAppStoreLauncher(
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async => false,
      );
      expect(await launcher.openStore(Uri.parse('https://apps.apple.com/es/app/id1')), isFalse);
    });

    test('devuelve false si la plataforma lanza', () async {
      final launcher = UrlLauncherAppStoreLauncher(
        launchUrlFn: (final url, {final LaunchMode mode = LaunchMode.platformDefault}) async => throw StateError('boom'),
      );
      expect(await launcher.openStore(Uri.parse('https://apps.apple.com/es/app/id1')), isFalse);
    });
  });
}
