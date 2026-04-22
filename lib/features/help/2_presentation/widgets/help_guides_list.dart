/// Help guides list widget — shows guide cards with optional external links.
library;

import 'package:flutter/material.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_guide.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders a scrollable list of [HelpGuide] cards.
///
/// Each card shows the guide's title and summary. If [HelpGuide.externalUrl]
/// is set, an action button is displayed that opens the URL in an external
/// browser via [url_launcher].
class HelpGuidesList extends StatelessWidget {
  const HelpGuidesList({required this.guides, super.key});

  /// The list of guides to render.
  final List<HelpGuide> guides;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.space16),
      itemCount: guides.length,
      itemBuilder: (final context, final index) {
        final guide = guides[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.space12),
          child: Card(
            elevation: 0,
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              side: const BorderSide(color: AppColors.divider),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.space16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    guide.title,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    guide.summary,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  if (guide.externalUrl != null) ...[
                    const SizedBox(height: AppDimensions.space12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Semantics(
                        label: l10n.helpGuideExternalLink,
                        button: true,
                        child: TextButton.icon(
                          onPressed: () => _openUrl(guide.externalUrl!),
                          icon: const Icon(
                            Icons.open_in_new,
                            size: AppDimensions.iconSmall,
                          ),
                          label: Text(l10n.helpGuideExternalLink),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _openUrl(final String urlString) async {
    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
