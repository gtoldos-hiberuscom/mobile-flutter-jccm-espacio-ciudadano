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
      padding: appPagePadding(context, top: AppDimensions.space16, bottom: AppDimensions.space64),
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
      actionLabel: l10n.educationTitlesInfoMoreInformation,
      actionIcon: AppIcons.openInNew,
      actionHierarchy: AppButtonHierarchy.ghost,
      actionIsExpanded: false,
      actionIsExternalLink: true,
      actionAlignment: Alignment.center,
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
    final l10n = AppLocalizations.of(context);
    // Un título, un nodo, en orden de lectura (WCAG 1.3.1).
    final semanticLabel = [
      if (title.titleNumber.isNotEmpty) _spoken(l10n.myDataEducationTitleNumberLabel(title.titleNumber)),
      title.titleName,
      title.universityName,
      if (title.completionDate != null) '${_spoken(l10n.myDataEducationCompletionDateLabel)}: ${_DateRow.format(l10n, title.completionDate!)}',
      if (title.expeditionDate != null) '${_spoken(l10n.myDataEducationExpeditionDateLabel)}: ${_DateRow.format(l10n, title.expeditionDate!)}',
    ].join('. ');
    return Semantics(
      container: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: AppInfoCard(
          leadingBorderWidth: AppDimensions.space4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Figma CardInfo: título y número comparten cabecera, rematada
                // por un separador antes de la universidad y las fechas.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.neutral100)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.titleName,
                        style: AppTypography.leadingBold.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (title.titleNumber.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: AppDimensions.space4),
                          child: Text(
                            l10n.myDataEducationTitleNumberLabel(title.titleNumber),
                            style: AppTypography.captionUppercase.copyWith(
                              color: AppColors.textBlueMutedDark,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.space8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                  child: Text(
                    title.universityName,
                    style: AppTypography.bodyRegular.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                if (title.completionDate != null) ...[
                  _DateRow(
                    label: l10n.myDataEducationCompletionDateLabel,
                    date: title.completionDate!,
                  ),
                ],
                if (title.expeditionDate != null) ...[
                  _DateRow(
                    label: l10n.myDataEducationExpeditionDateLabel,
                    date: title.expeditionDate!,
                  ),
                ],
              ],
            ),
          ),
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
    final labelText = Text(
      label,
      style: AppTypography.captionUppercase.copyWith(
        color: AppColors.primary,
      ),
    );
    final dateText = Text(
      format(AppLocalizations.of(context), date),
      style: AppTypography.bodyRegular.copyWith(
        color: AppColors.primary,
      ),
    );
    // Con el texto ampliado la fecha, que no se encoge, dejaba a la etiqueta
    // una columna tan estrecha que se partía letra a letra: se apilan
    // (WCAG 1.4.4).
    if (MediaQuery.textScalerOf(context).scale(1) > 1.5) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            labelText,
            const SizedBox(height: AppDimensions.space4),
            dateText,
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
      child: Row(
        children: [
          Expanded(child: labelText),
          const SizedBox(width: AppDimensions.space16),
          dateText,
        ],
      ),
    );
  }

  static String format(final AppLocalizations l10n, final DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

/// Rótulo en mayúsculas pasado a frase para el lector de pantalla, que de
/// otro modo puede deletrearlo («FECHA EXPEDICIÓN» → «Fecha expedición»).
String _spoken(final String value) {
  final lower = value.trim().toLowerCase();
  return lower.isEmpty ? lower : '${lower[0].toUpperCase()}${lower.substring(1)}';
}
