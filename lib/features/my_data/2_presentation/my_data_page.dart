import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// User data hub — Figma node 43973:1850.
class MyDataPage extends ConsumerWidget {
  const MyDataPage({super.key});

  static const List<_MyDataSectionDefinition> _sections = [
    _MyDataSectionDefinition(
      title: _MyDataText.healthTitle,
      description: _MyDataText.healthDescription,
      icon: AppIcons.favorite,
      route: Routes.myDataHealth,
    ),
    _MyDataSectionDefinition(
      title: _MyDataText.socialWelfareTitle,
      description: _MyDataText.socialWelfareDescription,
      icon: AppIcons.diversity,
    ),
    _MyDataSectionDefinition(
      title: _MyDataText.employmentTitle,
      description: _MyDataText.employmentDescription,
      icon: AppIcons.work,
    ),
    _MyDataSectionDefinition(
      title: _MyDataText.educationTitle,
      description: _MyDataText.educationDescription,
      icon: AppIcons.school,
    ),
    _MyDataSectionDefinition(
      title: _MyDataText.housingTitle,
      description: _MyDataText.housingDescription,
      icon: AppIcons.cottage,
    ),
    _MyDataSectionDefinition(
      title: _MyDataText.vehiclesTitle,
      description: _MyDataText.vehiclesDescription,
      icon: AppIcons.directionsCar,
    ),
  ];

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sections = _sections.map((final section) => section.resolve(l10n)).toList(growable: false);

    return Scaffold(
      appBar: AppNavBar(
        title: l10n.myDataTitle,
        isLoggedIn: true,
        showLeading: false,
        onAvatarTap: () => showAuthenticatedProfileMenu(context: context, ref: ref),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.backgroundBlueLighter,
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.space16,
              AppDimensions.space24,
              AppDimensions.space16,
              AppDimensions.space24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.myDataIntro,
                  style: AppTypography.bodyRegular.copyWith(
                    color: AppColors.textBase,
                  ),
                ),
                const SizedBox(height: AppDimensions.space20),
                for (final section in sections) ...[
                  _MyDataCard(
                    section: section,
                    onTap: () {
                      final route = section.route;
                      if (route == null) {
                        AppAlertSnackbar.show(
                          context,
                          message: l10n.myDataSectionComingSoon(section.title),
                        );
                        return;
                      }
                      context.go(route);
                    },
                  ),
                  const SizedBox(height: AppDimensions.space16),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MyDataSectionDefinition {
  const _MyDataSectionDefinition({
    required this.title,
    required this.description,
    required this.icon,
    this.route,
  });

  final _MyDataText title;
  final _MyDataText description;
  final IconData icon;
  final String? route;

  _MyDataSection resolve(final AppLocalizations l10n) {
    return _MyDataSection(
      title: title.resolve(l10n),
      description: description.resolve(l10n),
      icon: icon,
      route: route,
    );
  }
}

enum _MyDataText {
  healthTitle,
  healthDescription,
  socialWelfareTitle,
  socialWelfareDescription,
  employmentTitle,
  employmentDescription,
  educationTitle,
  educationDescription,
  housingTitle,
  housingDescription,
  vehiclesTitle,
  vehiclesDescription
  ;

  String resolve(final AppLocalizations l10n) {
    return switch (this) {
      _MyDataText.healthTitle => l10n.myDataHealthTitle,
      _MyDataText.healthDescription => l10n.myDataHealthDescription,
      _MyDataText.socialWelfareTitle => l10n.myDataSocialWelfareTitle,
      _MyDataText.socialWelfareDescription => l10n.myDataSocialWelfareDescription,
      _MyDataText.employmentTitle => l10n.myDataEmploymentTitle,
      _MyDataText.employmentDescription => l10n.myDataEmploymentDescription,
      _MyDataText.educationTitle => l10n.myDataEducationTitle,
      _MyDataText.educationDescription => l10n.myDataEducationDescription,
      _MyDataText.housingTitle => l10n.myDataHousingTitle,
      _MyDataText.housingDescription => l10n.myDataHousingDescription,
      _MyDataText.vehiclesTitle => l10n.myDataVehiclesTitle,
      _MyDataText.vehiclesDescription => l10n.myDataVehiclesDescription,
    };
  }
}

class _MyDataCard extends StatelessWidget {
  const _MyDataCard({
    required this.section,
    required this.onTap,
  });

  final _MyDataSection section;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    return Semantics(
      button: true,
      label: '${section.title}. ${section.description}',
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
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space8,
                AppDimensions.space8,
                AppDimensions.space16,
                AppDimensions.space8,
              ),
              child: Row(
                children: [
                  _MyDataIcon(icon: section.icon),
                  const SizedBox(width: AppDimensions.space16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppDimensions.space4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            section.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.leadingMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space4),
                          Text(
                            section.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.smallRegular.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.space8),
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

class _MyDataIcon extends StatelessWidget {
  const _MyDataIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: AppDimensions.space64,
      constraints: const BoxConstraints(minHeight: 64),
      decoration: BoxDecoration(
        color: AppColors.backgroundBlueLighter,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      alignment: Alignment.center,
      child: AppIcon(
        icon,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _MyDataSection {
  const _MyDataSection({
    required this.title,
    required this.description,
    required this.icon,
    this.route,
  });

  final String title;
  final String description;
  final IconData icon;
  final String? route;
}
