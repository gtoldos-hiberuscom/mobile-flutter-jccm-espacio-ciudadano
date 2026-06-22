import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/0_entity/employment_demand.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_employment_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

/// Employment detail page — Figma nodes 43973:1993 and 43973:2077.
class MyDataEmploymentPage extends StatefulWidget {
  const MyDataEmploymentPage({super.key});

  @override
  State<MyDataEmploymentPage> createState() => _MyDataEmploymentPageState();
}

class _MyDataEmploymentPageState extends State<MyDataEmploymentPage> {
  _EmploymentTab _selectedTab = _EmploymentTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataEmploymentTitle,
      onBack: () => context.go(Routes.myData),
      onInfo: () => _showEmploymentInfoSheet(context),
      tabs: [l10n.myDataEmploymentDataTab, l10n.myDataEmploymentServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _EmploymentTab.values[index]),
      tabViews: const [
        _EmploymentDataTab(),
        _EmploymentServicesTab(),
      ],
    );
  }

  Future<void> _showEmploymentInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataEmploymentInfoSheetTitle,
      bodyText: l10n.myDataEmploymentInfoSheetDescription,
    );
  }
}

enum _EmploymentTab { data, services }

class _EmploymentDataTab extends ConsumerWidget {
  const _EmploymentDataTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final demandAsync = ref.watch(employmentDemandProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        children: [
          demandAsync.when(
            data: (final demand) => demand == null ? const _EmploymentDemandEmpty() : _EmploymentDemandCard(demand: demand),
            loading: () => const Padding(
              padding: EdgeInsets.all(AppDimensions.space24),
              child: AppLoadingIndicator(),
            ),
            error: (final error, final stackTrace) => _EmploymentDemandError(
              onRetry: () => ref.invalidate(employmentDemandProvider),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          AppNavigationCard(
            title: AppLocalizations.of(context).myDataEmploymentOffersTitle,
            description: AppLocalizations.of(context).myDataEmploymentOffersDescription,
            onTap: () => AppAlertSnackbar.show(
              context,
              message: AppLocalizations.of(context).myDataSectionComingSoon(
                AppLocalizations.of(context).myDataEmploymentOffersTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmploymentDemandCard extends StatelessWidget {
  const _EmploymentDemandCard({required this.demand});

  final EmploymentDemand demand;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 110),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                child: Text(
                  _display(demand.status).toUpperCase(),
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.borderBlueMutedBase),
                ),
              ),
              Text(
                l10n.myDataEmploymentDemandTitle,
                style: AppTypography.leadingBold.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.space8),
              Text(
                l10n.myDataEmploymentRegistrationDateLabel.toUpperCase(),
                style: AppTypography.captionUppercase.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppDimensions.space4),
              Text(
                _formatDate(context, demand.uninterruptedRegistrationDate),
                style: AppTypography.smallRegular.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmploymentDemandEmpty extends StatelessWidget {
  const _EmploymentDemandEmpty();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Text(
          l10n.myDataEmploymentDemandEmpty,
          style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

class _EmploymentDemandError extends StatelessWidget {
  const _EmploymentDemandError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppInfoCard(
      leadingBorderWidth: AppDimensions.space4,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space16),
        child: Column(
          children: [
            Text(
              l10n.myDataEmploymentDemandError,
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.space16),
            AppButton(
              label: l10n.errorStateRetry,
              hierarchy: AppButtonHierarchy.secondary,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmploymentServicesTab extends StatelessWidget {
  const _EmploymentServicesTab();

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space24,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExternalLinkSection(
            title: l10n.myDataEmploymentProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureProfessionalCertificate,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureJobSeekerRegistration,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentProcedureVirtualOfficeCredentials,
                onTap: () => _launchExternalUrl(context, 'https://www.jccm.es/tramites'),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataEmploymentInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEmploymentLinkEmploymentClm,
                onTap: () => _launchExternalUrl(context, 'https://empleo.castillalamancha.es/'),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEmploymentLinkPublicEmploymentClm,
                onTap: () => _launchExternalUrl(context, 'https://empleopublico.castillalamancha.es/'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<void> _launchExternalUrl(final BuildContext context, final String urlString) async {
  final uri = Uri.parse(urlString);
  final accepted = await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );

  if (!accepted && context.mounted) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).externalLinkOpenFailed,
    );
  }
}

String _display(final String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return '-';
  }
  return normalized;
}

String _formatDate(final BuildContext context, final DateTime? date) {
  if (date == null) {
    return '-';
  }
  final months = AppLocalizations.of(context).localeName.toLowerCase().startsWith('en') ? const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'] : const ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
