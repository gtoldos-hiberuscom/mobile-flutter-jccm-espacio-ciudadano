import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/3_data/external_link_catalog_impl.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/0_entity/sitemap_node.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/3_data/sitemap_repository_impl.dart';

Iterable<SitemapNode> _flatten(final SitemapNode node) sync* {
  yield node;
  for (final c in node.children) {
    yield* _flatten(c);
  }
}

void main() {
  group('SitemapRepositoryImpl', () {
    const catalog = ExternalLinkCatalogImpl();
    const repo = SitemapRepositoryImpl(catalog: catalog);
    final tree = repo.loadTree();
    final allNodes = tree.expand(_flatten).toList(growable: false);
    final ids = allNodes.map((final n) => n.id).toSet();

    test('top-level groups are present', () {
      final groupIds = tree.map((final n) => n.id).toSet();
      expect(
        groupIds,
        equals(<String>{
          'group_authenticated',
          'group_thematic',
          'group_help_legal',
          'group_external',
        }),
      );
    });

    test('contains every authenticated, thematic, help and legal id', () {
      expect(
        ids,
        containsAll(<String>{
          'home',
          'agenda',
          'casework',
          'notifications',
          'cards',
          'recommendations',
          'support',
          'profile',
          'education',
          'employment',
          'social_welfare',
          'state_affairs',
          'help',
          'terms',
          'privacy',
          'accessibility',
          'legal_notice',
        }),
      );
    });

    test('internal nodes point to canonical Routes.* values', () {
      final routes = {
        for (final n in allNodes)
          if (n.route != null) n.id: n.route,
      };
      expect(routes['home'], Routes.home);
      expect(routes['agenda'], Routes.agenda);
      expect(routes['casework'], Routes.casework);
      expect(routes['help'], Routes.help);
      expect(routes['terms'], Routes.terms);
      expect(routes['privacy'], Routes.privacy);
    });

    test('external nodes delegate to the catalog by id', () {
      final externalGroup = tree.firstWhere((final n) => n.id == 'group_external');
      final externalIds = externalGroup.children.map((final n) => n.externalLinkId).toSet();
      // every external id must exist in the catalog (no hard-coded URLs)
      for (final id in externalIds) {
        expect(catalog.findById(id!), isNotNull, reason: 'sitemap external id "$id" must exist in the catalog');
      }
      // and every catalog entry should be reachable from the sitemap
      final catalogIds = catalog.all().map((final l) => l.id).toSet();
      expect(externalIds, equals(catalogIds));
    });

    test('a node cannot be both internal and external', () {
      for (final n in allNodes) {
        expect(n.route != null && n.externalLinkId != null, isFalse);
      }
    });
  });
}
