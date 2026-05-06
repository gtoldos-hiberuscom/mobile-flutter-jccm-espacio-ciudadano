import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/0_entity/sitemap_node.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/1_domain/sitemap_provider.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/2_presentation/sitemap_localizations.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Sitemap page (STORY-62).
///
/// Renders the navigation tree as a list of [ExpansionTile] groups.
/// Internal nodes call `context.go(route)`; external nodes use
/// [ExternalLinkButton] so they reuse the catalog-backed launcher
/// (canon §24).
class SitemapPage extends ConsumerWidget {
  const SitemapPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final tree = ref.watch(sitemapRepositoryProvider).loadTree();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sitemapPageTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
        children: tree.map((final node) => _SitemapGroup(node: node)).toList(growable: false),
      ),
    );
  }
}

class _SitemapGroup extends ConsumerWidget {
  const _SitemapGroup({required this.node});
  final SitemapNode node;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = resolveSitemapKey(l10n, node.titleKey);
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      children: node.children.map((final child) => _SitemapLeaf(node: child)).toList(growable: false),
    );
  }
}

class _SitemapLeaf extends ConsumerWidget {
  const _SitemapLeaf({required this.node});
  final SitemapNode node;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = resolveSitemapKey(l10n, node.titleKey);

    if (node.isExternal) {
      final ExternalLink? link = ref.watch(externalLinkCatalogProvider).findById(node.externalLinkId!);
      if (link == null) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space4,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: ExternalLinkButton(link: link, label: title),
        ),
      );
    }

    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: node.route == null ? null : () => context.go(node.route!),
    );
  }
}
