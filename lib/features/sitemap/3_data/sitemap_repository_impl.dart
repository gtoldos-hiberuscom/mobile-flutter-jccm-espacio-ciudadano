import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/0_entity/sitemap_node.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/1_domain/sitemap_repository.dart';

/// Builds the sitemap tree from:
///  - local route registry (`Routes.*`) for internal destinations,
///  - the injected [ExternalLinkCatalog] for outbound destinations.
///
/// The implementation never hard-codes outbound URLs — it only references
/// the catalog by `ExternalLink.id`, which keeps STORY-28's allow-list
/// authoritative (canon §24).
final class SitemapRepositoryImpl implements SitemapRepository {
  const SitemapRepositoryImpl({required this.catalog});

  final ExternalLinkCatalog catalog;

  @override
  List<SitemapNode> loadTree() {
    // External nodes are filtered against the catalog so that any link
    // missing from the allow-list silently disappears from the tree
    // instead of leaking a placeholder ID into the UI.
    SitemapNode? extById(final String id, final String titleKey) {
      final ExternalLink? entry = catalog.findById(id);
      if (entry == null) {
        return null;
      }
      return SitemapNode(
        id: 'ext_$id',
        titleKey: titleKey,
        externalLinkId: id,
      );
    }

    final List<SitemapNode> external = <SitemapNode?>[
      extById('educamos_clm', 'externalLinkEducamosClmLabel'),
      extById('empleo_clm', 'externalLinkEmpleoClmLabel'),
      extById('empleo_publico_clm', 'externalLinkEmpleoPublicoClmLabel'),
      extById('sede_dgt', 'externalLinkSedeDgtLabel'),
      extById('carpeta_ciudadana_age', 'externalLinkCarpetaCiudadanaAgeLabel'),
      extById('historia_social_unica', 'externalLinkHistoriaSocialUnicaLabel'),
      extById('bienestar_social_clm', 'externalLinkBienestarSocialClmLabel'),
      extById('infancia_familias', 'externalLinkInfanciaFamiliasLabel'),
    ].whereType<SitemapNode>().toList(growable: false);

    return <SitemapNode>[
      const SitemapNode(
        id: 'group_authenticated',
        titleKey: 'sitemapGroupAuthenticated',
        children: <SitemapNode>[
          SitemapNode(
            id: 'home',
            titleKey: 'sitemapHome',
            route: Routes.home,
          ),
          SitemapNode(
            id: 'agenda',
            titleKey: 'sitemapAgenda',
            route: Routes.agenda,
          ),
          SitemapNode(
            id: 'casework',
            titleKey: 'sitemapCasework',
            route: Routes.casework,
          ),
          SitemapNode(
            id: 'notifications',
            titleKey: 'sitemapNotifications',
            route: Routes.notifications,
          ),
          SitemapNode(
            id: 'cards',
            titleKey: 'sitemapCards',
            route: Routes.cards,
          ),
          SitemapNode(
            id: 'recommendations',
            titleKey: 'sitemapRecommendations',
            route: Routes.recommendations,
          ),
          SitemapNode(
            id: 'support',
            titleKey: 'sitemapSupport',
            route: Routes.support,
          ),
          SitemapNode(
            id: 'profile',
            titleKey: 'sitemapProfile',
            route: Routes.profile,
          ),
        ],
      ),
      const SitemapNode(
        id: 'group_thematic',
        titleKey: 'sitemapGroupThematic',
        children: <SitemapNode>[
          SitemapNode(
            id: 'education',
            titleKey: 'sitemapEducation',
            route: Routes.education,
          ),
          SitemapNode(
            id: 'employment',
            titleKey: 'sitemapEmployment',
            route: Routes.employment,
          ),
          SitemapNode(
            id: 'social_welfare',
            titleKey: 'sitemapSocialWelfare',
            route: Routes.socialWelfare,
          ),
          SitemapNode(
            id: 'state_affairs',
            titleKey: 'sitemapStateAffairs',
            route: Routes.stateAffairs,
          ),
        ],
      ),
      const SitemapNode(
        id: 'group_help_legal',
        titleKey: 'sitemapGroupHelpLegal',
        children: <SitemapNode>[
          SitemapNode(
            id: 'help',
            titleKey: 'sitemapHelp',
            route: Routes.help,
          ),
          SitemapNode(
            id: 'terms',
            titleKey: 'legalTermsTitle',
            route: Routes.terms,
          ),
          SitemapNode(
            id: 'privacy',
            titleKey: 'legalPrivacyTitle',
            route: Routes.privacy,
          ),
          SitemapNode(
            id: 'accessibility',
            titleKey: 'legalAccessibilityTitle',
            route: Routes.accessibility,
          ),
          SitemapNode(
            id: 'legal_notice',
            titleKey: 'legalNoticeTitle',
            route: Routes.legalNotice,
          ),
        ],
      ),
      SitemapNode(
        id: 'group_external',
        titleKey: 'sitemapGroupExternal',
        children: external,
      ),
    ];
  }
}
