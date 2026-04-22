import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/0_entity/sitemap_entry.dart';
import 'package:jccm_espacio_ciudadano/features/sitemap/1_domain/sitemap_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Navigable sitemap listing all major app sections and global links.
class SitemapPage extends ConsumerWidget {
  const SitemapPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sections = ref.watch(sitemapProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sitemapTitle)),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: sections.length,
        itemBuilder: (final context, final index) {
          final section = sections[index];
          return _SitemapSectionTile(section: section);
        },
      ),
    );
  }
}

class _SitemapSectionTile extends StatelessWidget {
  const _SitemapSectionTile({required this.section});

  final SitemapEntry section;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    if (section.children.isEmpty) {
      return _buildTile(context, section, indent: 0);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.route.isNotEmpty)
          _buildTile(context, section, indent: 0)
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              section.label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ...section.children.map(
          (final child) =>
              _buildTile(context, child, indent: section.route.isEmpty ? 1 : 2),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildTile(
    final BuildContext context,
    final SitemapEntry entry, {
    required final int indent,
  }) {
    return Semantics(
      button: true,
      label: entry.isExternal ? '${entry.label} (enlace externo)' : entry.label,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 16.0 + (indent * 16.0), right: 16),
        title: Text(entry.label),
        trailing: entry.isExternal
            ? const Icon(Icons.open_in_new, size: 16)
            : const Icon(Icons.chevron_right),
        onTap: () async {
          if (entry.isExternal) {
            final uri = Uri.parse(entry.route);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          } else if (entry.route.isNotEmpty) {
            context.go(entry.route);
          }
        },
      ),
    );
  }
}
