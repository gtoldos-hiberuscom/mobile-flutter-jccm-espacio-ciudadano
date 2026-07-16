import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';

void main() {
  test('resolves JCCM Sede URLs for every environment', () {
    expect(_config('development').sedeBaseUrl, Uri.parse('https://sede-uat.cm-pre.jccm.es/'));
    expect(_config('preproduction').sedeBaseUrl, Uri.parse('https://sede.cm-pre.jccm.es/'));
    expect(_config('production').sedeBaseUrl, Uri.parse('https://www.jccm.es/'));
  });

  test('builds procedure URL from the active JCCM Sede', () {
    expect(
      _config('production').procedureUrl(1023476),
      Uri.parse('https://www.jccm.es/tramites/1023476'),
    );
  });
}

AppConfig _config(final String flavor) => AppConfig.fromMap({
  'APP_FLAVOR': flavor,
});
