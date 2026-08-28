import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart' show ExternalLinkCatalog;
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/providers/external_links_provider.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_button.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/widgets/external_link_label.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Card variant for dashboard surfaces whose Sprint-3 implementation is
/// shipped as an outbound link via the [ExternalLinkCatalog]
/// (TASK-27 EXTERNAL_LINK decision).
///
/// Renders a localized title, an explanatory paragraph and an
/// [ExternalLinkButton] resolved from a catalog `id` so the allow-list
/// contract is preserved (no raw URL inputs).
class ExternalLinkCard extends ConsumerWidget {
  const ExternalLinkCard({
    required this.title,
    required this.description,
    required this.linkId,
    super.key,
    this.headingLevel = 3,
    this.titleSemanticLabel,
  }) : assert(title != '', 'title must not be empty'),
       assert(description != '', 'description must not be empty'),
       assert(linkId != '', 'linkId must not be empty'),
       assert(headingLevel >= 1 && headingLevel <= 6, 'headingLevel must be between 1 and 6'),
       assert(
         titleSemanticLabel == null || titleSemanticLabel != '',
         'titleSemanticLabel must not be empty',
       );

  final String title;
  final String description;

  /// Semantic heading level for the card title.
  final int headingLevel;

  /// Optional spoken form of [title] when it contains abbreviations.
  final String? titleSemanticLabel;

  /// Stable id from the [ExternalLinkCatalog].
  final String linkId;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ExternalLink? link = ref.watch(externalLinkCatalogProvider).findById(linkId);
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            headingLevel: headingLevel,
            label: titleSemanticLabel,
            excludeSemantics: titleSemanticLabel != null,
            child: Text(
              title,
              style: AppTypography.bodyBold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Text(
            description,
            style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.space12),
          if (link != null)
            Align(
              alignment: Alignment.centerLeft,
              child: ExternalLinkButton(
                link: link,
                label: resolveExternalLinkLabel(l10n, link.displayKey),
              ),
            ),
        ],
      ),
    );
  }
}
