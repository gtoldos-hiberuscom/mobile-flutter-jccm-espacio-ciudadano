import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';

void main() {
  group('SSO_STEP_UP_PARAMS', () {
    test('vacío no añade parámetros, que es el caso de los tres entornos hoy', () {
      expect(_stepUpConfig('').ssoStepUpParameters, isEmpty);
      expect(_stepUpConfig('   ').ssoStepUpParameters, isEmpty);
    });

    test('parsea pares clave=valor', () {
      expect(
        _stepUpConfig('acr_values=substantial&foo=bar').ssoStepUpParameters,
        {'acr_values': 'substantial', 'foo': 'bar'},
      );
    });

    test('conserva el valor entero aunque lleve «=» dentro', () {
      expect(
        _stepUpConfig('acr_values=http://eidas.europa.eu/loa/high?a=b').ssoStepUpParameters,
        {'acr_values': 'http://eidas.europa.eu/loa/high?a=b'},
      );
    });

    // Elevar sin el parámetro sigue siendo mejor que no poder entrar, así que
    // una configuración mal puesta se ignora entera en vez de romper el login.
    test('un valor mal formado se ignora entero en vez de romper el login', () {
      expect(_stepUpConfig('sin-igual').ssoStepUpParameters, isEmpty);
      expect(_stepUpConfig('=solo-valor').ssoStepUpParameters, isEmpty);
      expect(_stepUpConfig('clave=').ssoStepUpParameters, isEmpty);
      expect(_stepUpConfig('acr_values=substantial&roto').ssoStepUpParameters, isEmpty);
    });
  });

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

  test('resolves the web support form for every environment', () {
    expect(_config('development').webSupportFormUrl, Uri.parse('https://espaciociudadano-uat.jccm.es/soporte'));
    expect(_config('preproduction').webSupportFormUrl, Uri.parse('https://espaciociudadano-pre.jccm.es/soporte'));
    expect(_config('production').webSupportFormUrl, Uri.parse('https://espaciociudadano.jccm.es/soporte'));
  });

  group('APP_STORE_ID', () {
    test('accepts the numeric App Store Connect id', () {
      expect(const AppConfig.fromMap({'APP_STORE_ID': '6795089236'}).appStoreId, '6795089236');
    });

    test('rejects a missing, empty or non-numeric id', () {
      expect(() => const AppConfig.fromMap({}).appStoreId, throwsException);
      expect(() => const AppConfig.fromMap({'APP_STORE_ID': ''}).appStoreId, throwsException);
      expect(() => const AppConfig.fromMap({'APP_STORE_ID': 'id6795089236'}).appStoreId, throwsException);
    });
  });

  group('config_*.json', () {
    Map<String, Object?> read(final String file) => (jsonDecode(File(file).readAsStringSync()) as Map<Object?, Object?>).cast<String, Object?>();

    for (final file in ['config_development.json', 'config_preproduction.json', 'config_production.json']) {
      test('$file has a known update source and a valid App Store id', () {
        final json = read(file);
        // An unknown value silently falls back to "api" at runtime: catch typos here.
        expect(json['APP_UPDATE_SOURCE'], isIn(['api', 'mock-forced', 'mock-recommended', 'mock-none']));
        expect(AppConfig.fromMap(json).appStoreId, '6795089236');
      });
    }

    test('production asks the real version server', () {
      // A mock source in production would force or hide updates for every citizen.
      expect(read('config_production.json')['APP_UPDATE_SOURCE'], 'api');
    });
  });
}

AppConfig _config(final String flavor) => AppConfig.fromMap({
  'APP_FLAVOR': flavor,
});

AppConfig _stepUpConfig(final String raw) => AppConfig.fromMap({'SSO_STEP_UP_PARAMS': raw});
