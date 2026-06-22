import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/non_university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_education_provider.dart';
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
        error: (final error, final stack) => _buildErrorState(context, l10n, ref),
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
      padding: const EdgeInsets.all(AppDimensions.space16),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Text(
          l10n.educationNonUniversityTitlesEmpty,
          style: AppTypography.bodyRegular.copyWith(
            color: AppColors.textBase,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildErrorState(
    final BuildContext context,
    final AppLocalizations l10n,
    final WidgetRef ref,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.educationNonUniversityTitlesError,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.textBase,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.maintenanceRetry,
              onPressed: () => ref.invalidate(nonUniversityTitlesProvider),
              hierarchy: AppButtonHierarchy.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInfoSheet(
    final BuildContext context,
    final AppLocalizations l10n,
  ) async {
    await AppInfoSheet.show(
      context: context,
      title: 'Sobre tus títulos no universitarios',
      bodyText: 'Consulta los datos de los títulos no universitarios que figuren en el registro.',
      footerText: 'Si alguno de tus datos no es correcto o no está actualizado, contacta con el Ministerio de Educación.',
    );
  }
}

class _NonUniversityTitleCard extends StatelessWidget {
  const _NonUniversityTitleCard({required this.title});

  final NonUniversityTitle title;

  @override
  Widget build(final BuildContext context) {
    return AppInfoCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book, Order, Folio numbers
            if (_hasReferenceNumbers) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                child: Text(
                  _buildReferenceText(),
                  style: AppTypography.captionUppercase.copyWith(
                    color: AppColors.borderBlueMutedBase,
                  ),
                  maxLines: 2,
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
                label: 'PROVINCIA',
                value: title.province!,
              ),
            ],

            // Expedition date
            if (title.expeditionDate != null) ...[
              _LabelValueRow(
                label: 'FECHA EXPEDICIÓN',
                value: _formatDate(title.expeditionDate!),
              ),
            ],

            // Completion date
            if (title.completionDate != null) ...[
              _LabelValueRow(
                label: 'FECHA FINALIZACIÓN',
                value: _formatDate(title.completionDate!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool get _hasReferenceNumbers => title.book != null || title.order != null || title.folio != null;

  String _buildReferenceText() {
    final parts = <String>[];

    if (title.book != null && title.book!.trim().isNotEmpty) {
      parts.add('LIBRO: ${title.book}');
    }

    if (title.order != null && title.order!.trim().isNotEmpty) {
      parts.add('ORDEN: ${title.order}');
    }

    if (title.folio != null && title.folio!.trim().isNotEmpty) {
      parts.add('FOLIO: ${title.folio}');
    }

    return parts.join('   |   ');
  }

  String _formatDate(final DateTime date) {
    final day = date.day;
    final month = _monthName(date.month);
    final year = date.year;
    return '$day $month $year';
  }

  String _monthName(final int month) {
    return switch (month) {
      1 => 'ene',
      2 => 'feb',
      3 => 'mar',
      4 => 'abr',
      5 => 'may',
      6 => 'jun',
      7 => 'jul',
      8 => 'ago',
      9 => 'sep',
      10 => 'oct',
      11 => 'nov',
      12 => 'dic',
      _ => '',
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTypography.captionUppercase.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyRegular.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
