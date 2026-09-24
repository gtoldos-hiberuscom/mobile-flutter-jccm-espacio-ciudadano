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

  test('resolves the configured procedure ids for all domains and environments', () {
    final uat = _config('development');
    final pre = _config('preproduction');
    final pro = _config('production');

    expect(uat.educationProcedure(0).toString(), endsWith('/tramites/16895'));
    expect(pre.healthProcedure(1).toString(), endsWith('/tramites/93239'));
    expect(pro.socialWelfareProcedure(2).toString(), endsWith('/tramites/1000750'));
    expect(uat.employmentProcedure(2).toString(), endsWith('/tramites/15620'));
    expect(pre.housingProcedure(1).toString(), endsWith('/tramites/91331'));
    expect(pro.vehiclesProcedure(1).toString(), endsWith('/tramites/1018539'));
  });

  test('keeps the documented UAT links that intentionally use PRE Sede', () {
    final config = _config('uat');
    expect(config.socialWelfareProcedure(1), Uri.parse('https://sede.cm-pre.jccm.es/tramites/94737'));
    expect(config.housingProcedure(0), Uri.parse('https://sede.cm-pre.jccm.es/tramites/94881'));
  });

  test('resolves environment-specific service portals', () {
    expect(_config('uat').teachingStaffUrl.host, 'portalpersonaldocente-uat.cm-pre.jccm.es');
    expect(_config('pre').digitalHealthUrl.host, 'sescampre.jccm.es');
    expect(_config('pro').employmentUrl.path, '/private/posicion-global');
  });

  test('resolves the authenticated support facade for every environment', () {
    expect(
      _config('development').authenticatedSupportUrl,
      Uri.parse('https://fachada-sede-api-uat.cm-pre.jccm.es/api/v1/soporte'),
    );
    expect(
      _config('preproduction').authenticatedSupportUrl,
      Uri.parse('https://fachada-sede-api-pre.cm-pre.jccm.es/api/v1/soporte'),
    );
    expect(
      _config('production').authenticatedSupportUrl,
      Uri.parse('https://fachada-sede-api.jccm.es/api/v1/soporte'),
    );
  });
}

AppConfig _config(final String flavor) => AppConfig.fromMap({
  'APP_FLAVOR': flavor,
});
