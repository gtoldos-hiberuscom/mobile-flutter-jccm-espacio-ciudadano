import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_education_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Non-university titles list page — Figma node 43973:1888.
class MyDataNonUniversityTitlesPage extends ConsumerWidget {
  const MyDataNonUniversityTitlesPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final titlesAsync = ref.watch(nonUniversityTitlesProvider);

    return AppDetailScaffold(
      title: l10n.educationNonUniversityTitlesTitle,
      onBack: () => context.go(Routes.myDataEducation),
      onInfo: () => _showInfoSheet(context, l10n),
      body: titlesAsync.when(
        data: (final titles) => _buildTitlesList(context, l10n, titles),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stack) => error is MyDataAuthorizationRequired ? MyDataAuthorizationRequiredState(returnTo: Routes.myDataEducationNonUniversityTitles, onAuthorized: () => ref.invalidate(nonUniversityTitlesProvider)) : _buildErrorState(context, l10n, ref),
      ),
    );
  }

  Widget _buildTitlesList(
    final BuildContext context,
    final AppLocalizations l10n,
    final List<NonUniversityTitle> titles,
  ) {
    if (titles.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    return SingleChildScrollView(
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space16),
      child: Column(
        children: [
          for (final title in titles) ...[
            _NonUniversityTitleCard(title: title),
            const SizedBox(height: AppDimensions.space16),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    return MyDataNoData(
      message: l10n.educationNonUniversityTitlesNoDataMessage,
      actionLabel: l10n.myDataNoDataContact,
      contactUrl: _nonUniversityTitlesContactUrl,
    );
  }

  Widget _buildErrorState(
    final BuildContext context,
    final AppLocalizations l10n,
    final WidgetRef ref,
  ) {
    return MyDataServiceUnavailable(
      message: l10n.educationNonUniversityTitlesServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: () => ref.invalidate(nonUniversityTitlesProvider),
    );
  }

  Future<void> _showInfoSheet(
    final BuildContext context,
    final AppLocalizations l10n,
  ) async {
    await AppInfoSheet.show(
      context: context,
      title: l10n.educationNonUniversityTitlesInfoTitle,
      bodyText: l10n.educationNonUniversityTitlesInfoBody,
      footerText: l10n.educationNonUniversityTitlesInfoFooter,
      // El pie decía "contacta con el Ministerio" sin dar forma de hacerlo.
      actionLabel: l10n.myDataNoDataContact,
      onActionPressed: () => launchExternalUrlWithConfirmation(context, Uri.parse(_nonUniversityTitlesContactUrl)),
      actionIcon: AppIcons.openInNew,
    );
  }
}

/// Portada del Ministerio de Educación, Formación Profesional y Deportes: sin
/// `/portada.html` la raíz del dominio no resuelve a la página pública.
const String _nonUniversityTitlesContactUrl = 'https://www.educacionfpydeportes.gob.es/portada.html';

class _NonUniversityTitleCard extends StatelessWidget {
  const _NonUniversityTitleCard({required this.title});

  final NonUniversityTitle title;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Un título, un nodo: referencias, titulación, centro y cada dato con su
    // etiqueta, en orden de lectura (WCAG 1.3.1).
    final semanticLabel = [
      if (_hasReferenceNumbers) _spoken(_buildReferenceText(l10n).replaceAll('   |   ', ', ')),
      title.titleName,
      title.centerName,
      if (title.province != null) '${_spoken(l10n.myDataEducationProvinceLabel)}: ${title.province}',
      if (title.expeditionDate != null) '${_spoken(l10n.myDataEducationExpeditionDateLabel)}: ${_formatDate(l10n, title.expeditionDate!)}',
      if (title.completionDate != null) '${_spoken(l10n.myDataEducationCompletionDateLabel)}: ${_formatDate(l10n, title.completionDate!)}',
    ].join('. ');
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: AppInfoCard(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Book, Order, Folio numbers
                if (_hasReferenceNumbers) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                    // 6,2:1 sobre blanco (WCAG 1.4.3); sin recorte al ampliar el
                    // texto (1.4.4).
                    child: Text(
                      _buildReferenceText(l10n),
                      style: AppTypography.captionUppercase.copyWith(
                        color: AppColors.textPlaceholder,
                      ),
                    ),
                  ),
                ],

                // Title name (larger, bold)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                  child: Text(
                    title.titleName,
                    style: AppTypography.leadingBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Center name
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                  child: Text(
                    title.centerName,
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                // Province
                if (title.province != null) ...[
                  _LabelValueRow(
                    label: l10n.myDataEducationProvinceLabel,
                    value: title.province!,
                  ),
                ],

                // Expedition date
                if (title.expeditionDate != null) ...[
                  _LabelValueRow(
                    label: l10n.myDataEducationExpeditionDateLabel,
                    value: _formatDate(l10n, title.expeditionDate!),
                  ),
                ],

                // Completion date
                if (title.completionDate != null) ...[
                  _LabelValueRow(
                    label: l10n.myDataEducationCompletionDateLabel,
                    value: _formatDate(l10n, title.completionDate!),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool get _hasReferenceNumbers => title.book != null || title.order != null || title.folio != null;

  String _buildReferenceText(final AppLocalizations l10n) {
    final parts = <String>[];

    if (title.book != null && title.book!.trim().isNotEmpty) {
      parts.add(l10n.myDataEducationBookLabel(title.book!));
    }

    if (title.order != null && title.order!.trim().isNotEmpty) {
      parts.add(l10n.myDataEducationOrderLabel(title.order!));
    }

    if (title.folio != null && title.folio!.trim().isNotEmpty) {
      parts.add(l10n.myDataEducationFolioLabel(title.folio!));
    }

    return parts.join('   |   ');
  }

  String _formatDate(final AppLocalizations l10n, final DateTime date) {
    final day = date.day;
    final month = l10n.commonMonthShortName(_monthKey(date.month));
    final year = date.year;
    return '$day $month $year';
  }

  String _monthKey(final int month) {
    return switch (month) {
      1 => 'january',
      2 => 'february',
      3 => 'march',
      4 => 'april',
      5 => 'may',
      6 => 'june',
      7 => 'july',
      8 => 'august',
      9 => 'september',
      10 => 'october',
      11 => 'november',
      12 => 'december',
      _ => 'other',
    };
  }
}

class _LabelValueRow extends StatelessWidget {
  const _LabelValueRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(final BuildContext context) {
    final labelText = Text(
      label,
      style: AppTypography.captionUppercase.copyWith(
        color: AppColors.primary,
      ),
    );
    final valueText = Text(
      value,
      style: AppTypography.bodyRegular.copyWith(
        color: AppColors.primary,
      ),
    );
    // Con el texto ampliado etiqueta y valor se apilan en lugar de repartirse
    // dos columnas estrechas (WCAG 1.4.4).
    if (MediaQuery.textScalerOf(context).scale(1) > 1.5) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelText,
            const SizedBox(height: AppDimensions.space4),
            valueText,
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: labelText),
          const SizedBox(width: AppDimensions.space16),
          Expanded(child: valueText),
        ],
      ),
    );
  }
}

/// Rótulo en mayúsculas pasado a frase para el lector de pantalla, que de
/// otro modo puede deletrearlo («FECHA EXPEDICIÓN» → «Fecha expedición»).
String _spoken(final String value) {
  final lower = value.trim().toLowerCase();
  return lower.isEmpty ? lower : '${lower[0].toUpperCase()}${lower.substring(1)}';
}
