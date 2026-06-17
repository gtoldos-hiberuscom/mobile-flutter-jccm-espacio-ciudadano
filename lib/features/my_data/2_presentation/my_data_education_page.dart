import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Education data detail — Figma node 43973:1875.
class MyDataEducationPage extends StatefulWidget {
  const MyDataEducationPage({super.key});

  @override
  State<MyDataEducationPage> createState() => _MyDataEducationPageState();
}

class _MyDataEducationPageState extends State<MyDataEducationPage> {
  _EducationTab _selectedTab = _EducationTab.data;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppHeaderBar(
        title: l10n.myDataEducationTitle,
        onBack: () => context.go(Routes.myData),
        onInfo: () => _showEducationInfoSheet(context),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              AppTopTabBar(
                tabs: [l10n.myDataEducationDataTab, l10n.myDataEducationServicesTab],
                selectedIndex: _selectedTab.index,
                onTabSelected: (final index) => setState(() => _selectedTab = _EducationTab.values[index]),
              ),
              Expanded(
                child: switch (_selectedTab) {
                  _EducationTab.data => const _EducationDataTab(),
                  _EducationTab.services => const _EducationServicesTab(),
                },
              ),
            ],
          ),
        ),
      ),
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

class _EducationDataTab extends StatelessWidget {
  const _EducationDataTab();

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
          _EducationNavCard(
            title: l10n.myDataEducationUniversityTitles,
            description: l10n.myDataEducationTitlesDescription,
            onTap: () => context.go(Routes.myDataEducationUniversityTitles),
          ),
          const SizedBox(height: AppDimensions.space16),
          _EducationNavCard(
            title: l10n.myDataEducationNonUniversityTitles,
            description: l10n.myDataEducationTitlesDescription,
            onTap: () => context.go(Routes.myDataEducationNonUniversityTitles),
          ),
        ],
      ),
    );
  }
}

class _EducationNavCard extends StatelessWidget {
  const _EducationNavCard({
    required this.title,
    required this.description,
    this.onTap,
  });

  final String title;
  final String description;
  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      label: '$title. $description',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.borderBlueMutedLight),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          boxShadow: AppShadows.medium,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap:
                onTap ??
                () => AppAlertSnackbar.show(
                  context,
                  message: l10n.myDataSectionComingSoon(title),
                ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space24,
                AppDimensions.space16,
                AppDimensions.space16,
                AppDimensions.space16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.leadingMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space4),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.smallRegular.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space16),
                  const AppIcon(
                    AppIcons.arrowForward,
                    color: AppColors.textPrimary,
                    size: AppDimensions.iconLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          _EducationServicesSection(
            title: l10n.myDataEducationProceduresTitle,
            items: [
              l10n.myDataEducationProcedureEquivalence,
              l10n.myDataEducationProcedureScholarships,
              l10n.myDataEducationProcedureSecondaryDegree,
            ],
          ),
          const SizedBox(height: AppDimensions.space24),
          _EducationServicesSection(
            title: l10n.myDataEducationInterestLinksTitle,
            items: [
              l10n.myDataEducationInterestLinkPlaceholder,
              l10n.myDataEducationInterestLinkPlaceholder,
              l10n.myDataEducationInterestLinkPlaceholder,
            ],
          ),
        ],
      ),
    );
  }
}

class _EducationServicesSection extends StatelessWidget {
  const _EducationServicesSection({
    required this.title,
    required this.items,
  });

  final String title;
  final List<String> items;

  @override
  Widget build(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
          child: Text(
            title,
            style: AppTypography.h2.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.space8),
        for (final item in items) ...[
          _EducationServicesLink(label: item),
          const SizedBox(height: AppDimensions.space16),
        ],
      ],
    );
  }
}

class _EducationServicesLink extends StatelessWidget {
  const _EducationServicesLink({required this.label});

  final String label;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      link: true,
      label: label,
      child: InkWell(
        onTap: () => AppAlertSnackbar.show(
          context,
          message: l10n.myDataSectionComingSoon(label),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: AppDimensions.space16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: AppDimensions.space8),
                child: _EducationDoubleBullet(),
              ),
              const SizedBox(width: AppDimensions.space8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                  child: Text(
                    label,
                    style: AppTypography.bodyLink.copyWith(
                      color: AppColors.primary,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.space8),
              const Padding(
                padding: EdgeInsets.only(top: AppDimensions.space4),
                child: AppIcon(
                  AppIcons.openInNew,
                  color: AppColors.textBase,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EducationDoubleBullet extends StatelessWidget {
  const _EducationDoubleBullet();

  @override
  Widget build(final BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _EducationBulletDot(color: AppColors.primary),
        SizedBox(width: AppDimensions.space4),
        _EducationBulletDot(color: AppColors.secondary),
      ],
    );
  }
}

class _EducationBulletDot extends StatelessWidget {
  const _EducationBulletDot({required this.color});

  final Color color;

  @override
  Widget build(final BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: const SizedBox(
        width: AppDimensions.space8,
        height: AppDimensions.space8,
      ),
    );
  }
}
