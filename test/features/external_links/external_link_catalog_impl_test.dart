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
}
