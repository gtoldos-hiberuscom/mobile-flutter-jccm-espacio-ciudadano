import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/external_link_catalog_impl.dart';

void main() {
  test('catalog contains the canonical education and social welfare links', () {
    const catalog = ExternalLinkCatalogImpl(
      config: AppConfig.fromMap({'APP_FLAVOR': 'preproduction'}),
    );

    expect(
      catalog.findById('educacion_clm')?.url,
      Uri.parse('https://educacion.castillalamancha.es/'),
    );
    expect(
      catalog.findById('bienestar_social_clm')?.url,
      Uri.parse('https://bienestarsocial.castillalamancha.es/'),
    );
  });

  test('el registro de actividades de tratamiento apunta a la ficha, no al buscador', () {
    const catalog = ExternalLinkCatalogImpl(
      config: AppConfig.fromMap({'APP_FLAVOR': 'preproduction'}),
    );

    expect(
      catalog.findById('support_form_privacy_info')?.url,
      Uri.parse('https://rat.castillalamancha.es/detalle/2309'),
    );
  });

  test('las oficinas de Bienestar Social van filtradas, y las genéricas no', () {
    const catalog = ExternalLinkCatalogImpl(
      config: AppConfig.fromMap({'APP_FLAVOR': 'preproduction'}),
    );

    // Entradas distintas a propósito: la genérica la comparten Ayuda y
    // contacto, Accesibilidad y la dirección de Vivienda, donde el filtro por
    // consejería no tiene sentido.
    expect(
      catalog.findById('jccm_offices_oir_bienestar_social')?.url.queryParameters['search'],
      'Consejería Bienestar Social',
    );
    expect(
      catalog.findById('jccm_offices_oir')?.url.queryParameters,
      isEmpty,
    );
  });
}
