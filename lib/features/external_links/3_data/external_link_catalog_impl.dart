import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link_category.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart';

/// Hard-coded catalog of every outbound destination shipped with the
/// binary (STORY-28 acceptance criteria).
///
/// The list is intentionally hard-coded so it can also act as a security
/// allow-list at launch time — the launcher only opens URLs whose host
/// matches one of the entries below (no remote-controlled redirection).
///
/// To add a new destination:
///  1. Add a stable [ExternalLink.id] (snake_case, locale-independent).
///  2. Add the matching `external_link_<id>_label` ARB key to both
///     `app_es.arb` and `app_en.arb`.
///  3. Update the catalog test in
///     `test/features/external_links/external_link_catalog_test.dart`.
final class ExternalLinkCatalogImpl implements ExternalLinkCatalog {
  const ExternalLinkCatalogImpl();

  static final List<ExternalLink> _entries = <ExternalLink>[
    ExternalLink(
      id: 'educamos_clm',
      displayKey: 'externalLinkEducamosClmLabel',
      url: Uri.parse('https://educamosclm.castillalamancha.es/'),
      category: ExternalLinkCategory.educationCLM,
    ),
    ExternalLink(
      id: 'empleo_clm',
      displayKey: 'externalLinkEmpleoClmLabel',
      url: Uri.parse('https://empleo.castillalamancha.es/'),
      category: ExternalLinkCategory.employmentCLM,
    ),
    ExternalLink(
      id: 'empleo_publico_clm',
      displayKey: 'externalLinkEmpleoPublicoClmLabel',
      url: Uri.parse('https://empleopublico.castillalamancha.es/'),
      category: ExternalLinkCategory.publicEmploymentCLM,
    ),
    ExternalLink(
      id: 'sede_dgt',
      displayKey: 'externalLinkSedeDgtLabel',
      url: Uri.parse('https://sede.dgt.gob.es/'),
      category: ExternalLinkCategory.dgtElectronic,
    ),
    ExternalLink(
      id: 'carpeta_ciudadana_age',
      displayKey: 'externalLinkCarpetaCiudadanaAgeLabel',
      url: Uri.parse('https://carpetaciudadana.gob.es/'),
      category: ExternalLinkCategory.ageCarpetaCiudadana,
    ),
    ExternalLink(
      id: 'historia_social_unica',
      displayKey: 'externalLinkHistoriaSocialUnicaLabel',
      url: Uri.parse('https://historiasocial.castillalamancha.es/'),
      category: ExternalLinkCategory.socialHistoria,
    ),
    // STORY-25 / TASK-27 EXTERNAL_LINK fallback entry. Pending product
    // confirmation of the canonical landing URL for termalismo and
    // atención a la dependencia.
    ExternalLink(
      id: 'bienestar_social_clm',
      displayKey: 'externalLinkBienestarSocialClmLabel',
      url: Uri.parse('https://bienestarsocial.castillalamancha.es/'),
      category: ExternalLinkCategory.socialWelfareCLM,
    ),
    ExternalLink(
      id: 'infancia_familias',
      displayKey: 'externalLinkInfanciaFamiliasLabel',
      url: Uri.parse('https://infanciayfamilias.castillalamancha.es/'),
      category: ExternalLinkCategory.infanciaFamilias,
    ),
  ];

  @override
  List<ExternalLink> all() => List<ExternalLink>.unmodifiable(_entries);

  @override
  List<ExternalLink> byCategory(final ExternalLinkCategory category) =>
      List<ExternalLink>.unmodifiable(
        _entries.where((final ExternalLink e) => e.category == category),
      );

  @override
  ExternalLink? findById(final String id) {
    for (final ExternalLink entry in _entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }
}
