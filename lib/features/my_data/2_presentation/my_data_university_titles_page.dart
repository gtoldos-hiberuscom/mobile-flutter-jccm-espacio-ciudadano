import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/my_data_authorization_required.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/university_title.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_education_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_required_state.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_no_data.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_service_unavailable.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// University titles list page — Figma node 43973:1882.
class MyDataUniversityTitlesPage extends ConsumerWidget {
  const MyDataUniversityTitlesPage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final titlesAsync = ref.watch(universityTitlesProvider);

    return AppDetailScaffold(
      title: l10n.educationUniversityTitlesTitle,
      onBack: () => context.go(Routes.myDataEducation),
      onInfo: () => _showInfoSheet(context, l10n),
      body: titlesAsync.when(
        data: (final titles) => _buildTitlesList(context, l10n, titles),
        loading: () => const Center(child: AppLoadingIndicator()),
        error: (final error, final stack) => error is MyDataAuthorizationRequired ? MyDataAuthorizationRequiredState(returnTo: Routes.myDataEducationUniversityTitles, onAuthorized: () => ref.invalidate(universityTitlesProvider)) : _buildErrorState(context, l10n, ref),
      ),
    );
  }

  Widget _buildTitlesList(
    final BuildContext context,
    final AppLocalizations l10n,
    final List<UniversityTitle> titles,
  ) {
    if (titles.isEmpty) {
      return _buildEmptyState(context, l10n);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      itemCount: titles.length,
      separatorBuilder: (final context, final index) => const SizedBox(
        height: AppDimensions.space16,
      ),
      itemBuilder: (final context, final index) {
        return _UniversityTitleCard(title: titles[index]);
      },
    );
  }

  Widget _buildEmptyState(
    final BuildContext context,
    final AppLocalizations l10n,
  ) {
    return MyDataNoData(
      message: l10n.educationUniversityTitlesNoDataMessage,
      actionLabel: l10n.educationUniversityTitlesInfoContactButton,
      contactUrl: _universityTitlesContactUrl,
    );
  }

  Widget _buildErrorState(
    final BuildContext context,
    final AppLocalizations l10n,
    final WidgetRef ref,
  ) {
    return MyDataServiceUnavailable(
      message: l10n.educationUniversityTitlesServiceUnavailableMessage,
      actionLabel: l10n.myDataServiceUnavailableUpdate,
      onRetry: () => ref.invalidate(universityTitlesProvider),
    );
  }

  Future<void> _showInfoSheet(
    final BuildContext context,
    final AppLocalizations l10n,
  ) async {
    await AppInfoSheet.show(
      context: context,
      title: l10n.educationUniversityTitlesInfoTitle,
      bodyText: l10n.educationUniversityTitlesInfoBody,
      footerText: l10n.educationUniversityTitlesInfoFooter,
      actionLabel: l10n.educationUniversityTitlesInfoContactButton,
      actionIcon: AppIcons.openInNew,
      onActionPressed: () => _openContactUrl(context),
    );
  }

  Future<void> _openContactUrl(final BuildContext context) async {
    await launchExternalUrlWithConfirmation(context, Uri.parse(_universityTitlesContactUrl));
  }
}

/// Sede electrónica de Universidades, que es donde se consultan y corrigen los
/// títulos universitarios. Antes apuntaba al portal del ministerio, que no
/// lleva a ningún trámite.
const String _universityTitlesContactUrl = 'https://universidades.sede.gob.es/';

class _UniversityTitleCard extends StatelessWidget {
  const _UniversityTitleCard({required this.title});

  final UniversityTitle title;

  @override
  Widget build(final BuildContext context) {
    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title number
            if (title.titleNumber.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                child: Text(
                  'Nº TÍTULO: ${title.titleNumber}',
                  style: AppTypography.captionUppercase.copyWith(
                    color: AppColors.borderBlueMutedBase,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],

            // Title name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
              child: Text(
                title.titleName,
                style: AppTypography.leadingBold.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // University name
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
              child: Text(
                title.universityName,
                style: AppTypography.bodyRegular.copyWith(
                  color: AppColors.primary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Dates
            const SizedBox(height: AppDimensions.space4),
            if (title.completionDate != null) ...[
              _DateRow(
                label: 'FECHA FINALIZACIÓN',
                date: title.completionDate!,
              ),
            ],
            if (title.expeditionDate != null) ...[
              _DateRow(
                label: 'FECHA EXPEDICIÓN',
                date: title.expeditionDate!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.date,
  });

  final String label;
  final DateTime date;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
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
          Text(
            _formatDate(date),
            style: AppTypography.bodyRegular.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(final DateTime date) {
    final day = date.day;
    final month = _monthName(date.month);
    final year = date.year;
    return '$day $month $year';
  }

  String _monthName(final int month) => switch (month) {
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
