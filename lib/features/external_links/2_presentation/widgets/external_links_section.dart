import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/widgets/domain_section.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_label.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Renders the "Enlaces externos" block at the bottom of the thematic
/// landings (STORY-23/24/25/26). Accepts a list of catalog `id`s
/// instead of URLs so the allow-list contract is preserved.
///
/// Unknown ids are silently dropped — they are programming errors that
/// would surface immediately in the catalog test.
class ExternalLinksSection extends ConsumerWidget {
  const ExternalLinksSection({required this.linkIds, super.key});

  final List<String> linkIds;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final catalog = ref.watch(externalLinkCatalogProvider);
    final links = <ExternalLink>[
      for (final id in linkIds)
        if (catalog.findById(id) != null) catalog.findById(id)!,
    ];
    if (links.isEmpty) {
      return const SizedBox.shrink();
    }
    return DomainSection(
      title: l10n.domainExternalLinksTitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final link in links) ...[
            ExternalLinkButton(
              link: link,
              label: resolveExternalLinkLabel(l10n, link.displayKey),
            ),
            const SizedBox(height: AppDimensions.space8),
          ],
        ],
      ),
    );
  }
}
