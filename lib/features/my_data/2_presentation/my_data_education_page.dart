import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/providers/my_data_authorization_provider.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_authorization_contextual_helper.dart';
import 'package:jccm_espacio_ciudadano/features/my_data/2_presentation/widgets/my_data_disabled_navigation_card.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Education data detail — Figma node 43973:1875.
class MyDataEducationPage extends StatefulWidget {
  const MyDataEducationPage({
    super.key,
    this.backRoute = Routes.myData,
  });

  final String backRoute;

  @override
  State<MyDataEducationPage> createState() => _MyDataEducationPageState();
}

class _MyDataEducationPageState extends State<MyDataEducationPage> {
  _EducationTab _selectedTab = _EducationTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AppTabbedDetailScaffold(
      title: l10n.myDataEducationTitle,
      onBack: () => context.go(widget.backRoute),
      onInfo: () => _showEducationInfoSheet(context),
      tabs: [l10n.myDataEducationDataTab, l10n.myDataEducationServicesTab],
      selectedIndex: _selectedTab.index,
      onTabSelected: (final index) => setState(() => _selectedTab = _EducationTab.values[index]),
      tabViews: const [
        _EducationDataTab(),
        _EducationServicesTab(),
      ],
    );
  }

  Future<void> _showEducationInfoSheet(final BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await AppInfoSheet.show(
      context: context,
      title: l10n.myDataEducationInfoSheetTitle,
      bodyText: l10n.myDataEducationInfoSheetDescription,
    );
  }
}

enum _EducationTab { data, services }

class _EducationDataTab extends ConsumerWidget {
  const _EducationDataTab();

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final authorizationAsync = ref.watch(ageDataAuthorizationProvider);

    return authorizationAsync.when(
      data: (final hasAgeAuthorization) => _EducationDataContent(
        hasAgeAuthorization: hasAgeAuthorization,
      ),
      loading: () => const Center(child: AppLoadingIndicator()),
      error: (final error, final stackTrace) => const _EducationDataContent(
        hasAgeAuthorization: false,
      ),
    );
  }
}

class _EducationDataContent extends StatelessWidget {
  const _EducationDataContent({required this.hasAgeAuthorization});

  final bool hasAgeAuthorization;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space64,
      ),
      child: Column(
        children: [
          if (!hasAgeAuthorization) ...[
            MyDataAuthorizationContextualHelper(
              message: l10n.myDataAgeAuthorizationRequiredMessage,
              semanticsLabel: l10n.myDataJccmAuthorizationRequiredCta,
              onOpenSettings: () => _openSettings(context),
            ),
            const SizedBox(height: AppDimensions.space16),
          ],
          if (hasAgeAuthorization)
            AppNavigationCard(
              title: l10n.myDataEducationUniversityTitles,
              description: l10n.myDataEducationTitlesDescription,
              onTap: () => context.go(Routes.myDataEducationUniversityTitles),
            )
          else
            MyDataDisabledNavigationCard(
              title: l10n.myDataEducationUniversityTitles,
              description: l10n.myDataEducationTitlesDescription,
            ),
          const SizedBox(height: AppDimensions.space16),
          if (hasAgeAuthorization)
            AppNavigationCard(
              title: l10n.myDataEducationNonUniversityTitles,
              description: l10n.myDataEducationTitlesDescription,
              onTap: () => context.go(Routes.myDataEducationNonUniversityTitles),
            )
          else
            MyDataDisabledNavigationCard(
              title: l10n.myDataEducationNonUniversityTitles,
              description: l10n.myDataEducationTitlesDescription,
            ),
        ],
      ),
    );
  }

  void _openSettings(final BuildContext context) {
    context.go(
      Uri(
        path: Routes.consent,
        queryParameters: {
          'mode': 'preferences',
          'returnTo': Routes.myDataEducation,
        },
      ).toString(),
    );
  }
}

class _EducationServicesTab extends StatelessWidget {
  const _EducationServicesTab();

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
            title: l10n.myDataEducationProceduresTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEducationProcedureEquivalence,
                onTap: () => _showComingSoon(context, l10n.myDataEducationProcedureEquivalence),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationProcedureScholarships,
                onTap: () => _showComingSoon(context, l10n.myDataEducationProcedureScholarships),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationProcedureSecondaryDegree,
                onTap: () => _showComingSoon(context, l10n.myDataEducationProcedureSecondaryDegree),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          AppExternalLinkSection(
            title: l10n.myDataEducationInterestLinksTitle,
            links: [
              AppExternalLinkItem(
                label: l10n.myDataEducationInterestLinkPlaceholder,
                onTap: () => _showComingSoon(context, l10n.myDataEducationInterestLinkPlaceholder),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationInterestLinkPlaceholder,
                onTap: () => _showComingSoon(context, l10n.myDataEducationInterestLinkPlaceholder),
              ),
              AppExternalLinkItem(
                label: l10n.myDataEducationInterestLinkPlaceholder,
                onTap: () => _showComingSoon(context, l10n.myDataEducationInterestLinkPlaceholder),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showComingSoon(final BuildContext context, final String label) {
    AppAlertSnackbar.show(
      context,
      message: AppLocalizations.of(context).myDataSectionComingSoon(label),
    );
  }
}
