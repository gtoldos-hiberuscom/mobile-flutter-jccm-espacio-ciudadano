import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/legal/0_entity/legal_document.dart';
import 'package:jccm_espacio_ciudadano/features/legal/3_data/legal_repository_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Full-screen page that renders a bundled [LegalDocument].
///
/// ## Usage
/// Navigate to this page by passing the desired [LegalDocumentType]:
/// ```dart
/// context.push(Routes.legalTerms); // routed via LegalPage(documentType: ...)
/// ```
///
/// ## Architecture notes
/// - Content is fetched synchronously from [legalRepositoryProvider]; no
///   loading or error state is required.
/// - Offline-capable: all content is bundled — no network needed.
/// - Accessibility: the scrollable content area carries a [Semantics] label
///   so that screen readers can describe the region to the user.
class LegalPage extends ConsumerWidget {
  const LegalPage({required this.documentType, super.key});

  /// Identifies which legal document to display.
  final LegalDocumentType documentType;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final document = ref.watch(legalRepositoryProvider).getDocument(documentType);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(document.title),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Semantics(
          label: l10n.legalContentSemantics,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space24,
              vertical: AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  document.content.trim(),
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.7,
                  ),
                ),
                if (document.lastUpdated != null) ...[
                  const SizedBox(height: AppDimensions.space32),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppDimensions.space12),
                  Text(
                    l10n.legalPageLastUpdated(
                      LegalPage._formatDate(document.lastUpdated!),
                    ),
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.space32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Formats [date] as `dd/MM/yyyy` without requiring the `intl` package.
  static String _formatDate(final DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$dd/$mm/$yyyy';
  }
}
