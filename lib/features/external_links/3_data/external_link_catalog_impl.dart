import 'package:jccm_espacio_ciudadano/core/config/app_config.dart';
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
  const ExternalLinkCatalogImpl({required this.config});

  final AppConfig config;

  static final List<ExternalLink> _baseEntries = <ExternalLink>[
    ExternalLink(
      id: 'educamos_clm',
      displayKey: 'externalLinkEducamosClmLabel',
      url: Uri.parse('https://educamosclm.castillalamancha.es/'),
      category: ExternalLinkCategory.educationCLM,
    ),
    ExternalLink(
      id: 'educacion_clm',
      displayKey: 'externalLinkEducacionClmLabel',
      url: Uri.parse('https://educacion.castillalamancha.es/'),
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
    ExternalLink(
      id: 'aepd',
      displayKey: 'externalLinkAepdLabel',
      url: Uri.parse('https://www.aepd.es/'),
      category: ExternalLinkCategory.dataProtection,
    ),
    ExternalLink(
      id: 'boe_rd_1112_2018',
      displayKey: 'legalNoticeTitle',
      url: Uri.parse('https://www.boe.es/buscar/act.php?id=BOE-A-2018-12699'),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      id: 'espacio_ciudadano',
      displayKey: 'legalNoticeTitle',
      url: Uri.parse('https://espaciociudadano.jccm.es/'),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      id: 'accessibility_contact_form',
      displayKey: 'legalAccessibilityTitle',
      url: Uri.parse('https://ventanillaelectronica.jccm.es/administracion_electronica/formularios/CONSUL.phtml?SER_ID=IZY&PROC=SIRQ'),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      id: 'jccm_offices_oir',
      displayKey: 'legalAccessibilityTitle',
      url: Uri.parse(
        'https://www.jccm.es/index.php/atencion-a-la-ciudadania/oficinas-de-registro/oficinas-oir',
      ),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      // Las oficinas OIR filtradas por la Consejería de Bienestar Social. Va
      // aparte de `jccm_offices_oir` a propósito: esa entrada genérica la
      // comparten Ayuda y contacto, Accesibilidad y la dirección de Vivienda,
      // donde el filtro no tiene sentido.
      id: 'jccm_offices_oir_bienestar_social',
      displayKey: 'legalAccessibilityTitle',
      url: Uri.parse(
        'https://www.jccm.es/atencion-a-la-ciudadania/oficinas-de-registro/oficinas-oir?search=Consejer%C3%ADa+Bienestar+Social',
      ),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      id: 'help_guides',
      displayKey: 'helpPageTitle',
      url: Uri.parse('https://www.jccm.es/ayuda/guias-ayuda'),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      id: 'technical_support',
      displayKey: 'helpPageTitle',
      url: Uri.parse('https://espaciociudadano.jccm.es/'),
      category: ExternalLinkCategory.legalInformation,
    ),
    ExternalLink(
      id: 'support_form_privacy_info',
      displayKey: 'legalNoticeTitle',
      url: Uri.parse('https://rat.castillalamancha.es/detalle/2309'),
      category: ExternalLinkCategory.dataProtection,
    ),
  ];

  List<ExternalLink> get _entries => [
    ..._baseEntries.where((final entry) => !const {'educamos_clm', 'empleo_clm', 'historia_social_unica', 'infancia_familias'}.contains(entry.id)),
    ExternalLink(id: 'educamos_clm', displayKey: 'externalLinkEducamosClmLabel', url: config.educamosUrl, category: ExternalLinkCategory.educationCLM),
    ExternalLink(id: 'empleo_clm', displayKey: 'externalLinkEmpleoClmLabel', url: config.employmentUrl, category: ExternalLinkCategory.employmentCLM),
    ExternalLink(id: 'historia_social_unica', displayKey: 'externalLinkHistoriaSocialUnicaLabel', url: config.socialHistoryUrl, category: ExternalLinkCategory.socialHistoria),
    ExternalLink(id: 'infancia_familias', displayKey: 'externalLinkInfanciaFamiliasLabel', url: config.childrenAndFamiliesUrl, category: ExternalLinkCategory.infanciaFamilias),
    for (var index = 0; index < 3; index++) ExternalLink(id: 'social_welfare_procedure_$index', displayKey: 'externalLinkBienestarSocialClmLabel', url: config.socialWelfareProcedure(index), category: ExternalLinkCategory.socialWelfareCLM),
    ExternalLink(
      id: 'sede_jccm',
      displayKey: 'drawerGoToSedeElectronica',
      url: config.sedeBaseUrl,
      category: ExternalLinkCategory.jccmElectronic,
    ),
  ];

  @override
  List<ExternalLink> all() => List<ExternalLink>.unmodifiable(_entries);

  @override
  List<ExternalLink> byCategory(final ExternalLinkCategory category) => List<ExternalLink>.unmodifiable(
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
