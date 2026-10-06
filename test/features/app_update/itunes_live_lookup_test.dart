@Tags(['backend'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/app_version.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/0_entity/update_policy.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/api/itunes_lookup_api.dart';
import 'package:jccm_espacio_ciudadano/features/app_update/3_data/repositories/itunes_app_update_repository_impl.dart';

import 'support/app_update_fakes.dart';

/// Humo real contra iTunes (red), opt-in: `flutter test --tags backend`.
///
/// Usa una app publicada en el storefront español porque la nuestra aún no lo
/// está (hoy iTunes devuelve `resultCount: 0` para `es.jccm.espaciociudadano`).
void main() {
  test('la búsqueda de iTunes devuelve la versión publicada de una app real', () async {
    final repo = ItunesAppUpdateRepositoryImpl(
      api: ItunesLookupApi.standalone(),
      installed: FakeInstalledVersionRepository(const AppVersion(0, 0, 1), applicationIdValue: 'net.whatsapp.WhatsApp'),
    );

    final manifest = await repo.fetchManifest();

    expect(manifest.latestVersion > const AppVersion(0, 0, 0), isTrue);
    expect(manifest.minVersion, const AppVersion(0, 0, 0));
    expect(manifest.policy, UpdatePolicy.recommended);
    expect(manifest.storeUrl.host, 'apps.apple.com');
    expect(manifest.displayVersion, manifest.latestVersion.toString());
  });
}
