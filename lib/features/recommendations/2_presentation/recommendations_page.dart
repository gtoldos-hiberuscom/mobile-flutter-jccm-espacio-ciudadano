import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class RecommendationsPage extends ConsumerStatefulWidget {
  const RecommendationsPage({super.key});

  @override
  ConsumerState<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends ConsumerState<RecommendationsPage> {
  _RecommendationFilter _selectedFilter = _RecommendationFilter.all;
  bool _showNoRecommendationsBanner = true;

  static const List<AppBottomTabBarItem> _tabs = [
    AppBottomTabBarItem(label: 'Inicio', iconAsset: AppIconAssets.accountBalance),
    AppBottomTabBarItem(label: 'Gestión', iconAsset: AppIconAssets.docs),
    AppBottomTabBarItem(label: 'Mi Carpeta', iconAsset: AppIconAssets.apps),
    AppBottomTabBarItem(label: 'Agenda', iconAsset: AppIconAssets.calendarToday),
    AppBottomTabBarItem(label: 'Recomendados', iconAsset: AppIconAssets.license),
  ];

  void _handleTabTap(final int index) {
    switch (index) {
      case 0:
        context.go(Routes.home);
      case 3:
        context.go(Routes.agenda);
      case 4:
        return;
      default:
        return;
    }
  }

  void _goToLifeEvents() {
    context.go(Uri(path: Routes.lifeEvents, queryParameters: {'returnTo': Routes.recommendations}).toString());
  }

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(recommendationsProvider);

    return Scaffold(
      appBar: AppNavBar(
        title: l10n.recommendationsTitle,
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
          child: LayoutBuilder(
            builder: (final context, final constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.space16,
                AppDimensions.space24,
                AppDimensions.space16,
                AppDimensions.space24,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > AppDimensions.space48 ? constraints.maxHeight - AppDimensions.space48 : 0,
                ),
                child: state.when(
                  data: (final data) => _buildLoadedContent(context, data),
                  loading: _buildLoadingContent,
                  error: (final error, final stackTrace) => _buildErrorContent(context),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AppBottomTabBar(
        items: _tabs,
        currentIndex: 4,
        onTap: _handleTabTap,
      ),
    );
  }

  Widget _buildLoadedContent(final BuildContext context, final RecommendationsState state) {
    final recommendations = _selectedFilter.apply(state.recommendations);
    final hasRecommendations = state.recommendations.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          isEnabled: hasRecommendations,
          onSelected: (final filter) => setState(() => _selectedFilter = filter),
        ),
        const SizedBox(height: AppDimensions.space24),
        if (!state.hasConfiguredLifeEvents)
          _EmptyRecommendationsContent(
            showBanner: _showNoRecommendationsBanner,
            onDismissBanner: () => setState(() => _showNoRecommendationsBanner = false),
            onEditPreferences: _goToLifeEvents,
          )
        else ...[
          if (recommendations.isEmpty)
            _EmptyRecommendationsContent(
              showBanner: _showNoRecommendationsBanner,
              onDismissBanner: () => setState(() => _showNoRecommendationsBanner = false),
              onEditPreferences: _goToLifeEvents,
            )
          else
            for (final recommendation in recommendations) ...[
              _RecommendationCard(recommendation: recommendation),
              const SizedBox(height: AppDimensions.space16),
            ],
        ],
      ],
    );
  }

  Widget _buildLoadingContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          isEnabled: false,
        ),
        const SizedBox(height: AppDimensions.space32),
        const Center(child: AppLoadingIndicator()),
      ],
    );
  }

  Widget _buildErrorContent(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          isEnabled: true,
          onSelected: (final filter) => setState(() => _selectedFilter = filter),
        ),
        const SizedBox(height: AppDimensions.space32),
        Text(
          l10n.recommendationsLoadingError,
          style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppDimensions.space8),
        AppButton(
          label: l10n.recommendationsLoadingErrorRetry,
          onPressed: () => ref.invalidate(recommendationsProvider),
          leadingIcon: AppIcons.autorenew,
        ),
      ],
    );
  }
}

class _FilterNavigation extends StatelessWidget {
  const _FilterNavigation({
    required this.selectedFilter,
    required this.isEnabled,
    this.onSelected,
  });

  final _RecommendationFilter selectedFilter;
  final bool isEnabled;
  final ValueChanged<_RecommendationFilter>? onSelected;

  @override
  Widget build(final BuildContext context) {
    return _RecommendationFloatingNavigation(
      selectedFilter: selectedFilter,
      isEnabled: isEnabled,
      onSelected: onSelected,
    );
  }
}

class _RecommendationFloatingNavigation extends StatelessWidget {
  const _RecommendationFloatingNavigation({
    required this.selectedFilter,
    required this.isEnabled,
    required this.onSelected,
  });

  final _RecommendationFilter selectedFilter;
  final bool isEnabled;
  final ValueChanged<_RecommendationFilter>? onSelected;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      padding: const EdgeInsets.all(AppDimensions.space8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        border: Border.all(color: AppColors.borderNeutralLight),
      ),
      child: Row(
        spacing: AppDimensions.space8,
        children: [
          _RecommendationFilterTab(
            label: _RecommendationFilter.all.label(context),
            isSelected: selectedFilter == _RecommendationFilter.all,
            isEnabled: true,
            minWidth: 74,
            onTap: () => onSelected?.call(_RecommendationFilter.all),
          ),
          Expanded(
            child: _RecommendationFilterTab(
              label: _RecommendationFilter.recent.label(context),
              isSelected: selectedFilter == _RecommendationFilter.recent,
              isEnabled: isEnabled,
              minWidth: 112,
              onTap: () => onSelected?.call(_RecommendationFilter.recent),
            ),
          ),
          Expanded(
            child: _RecommendationFilterTab(
              label: _RecommendationFilter.news.label(context),
              isSelected: selectedFilter == _RecommendationFilter.news,
              isEnabled: isEnabled,
              minWidth: 112,
              onTap: () => onSelected?.call(_RecommendationFilter.news),
            ),
          ),
          SizedBox(
            width: AppDimensions.minTouchTarget,
            height: 40,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const AppIcon(AppIcons.arrowForward, color: AppColors.textPrimary),
              onPressed: () {},
              tooltip: _RecommendationFilter.news.label(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationFilterTab extends StatelessWidget {
  const _RecommendationFilterTab({
    required this.label,
    required this.isSelected,
    required this.isEnabled,
    required this.minWidth,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isEnabled;
  final double minWidth;
  final VoidCallback onTap;

  @override
  Widget build(final BuildContext context) {
    final backgroundColor = isSelected ? AppColors.backgroundBlueLighter : AppColors.background;
    final borderColor = isSelected ? AppColors.primaryDark : Colors.transparent;
    final textStyle = isSelected ? AppTypography.bodyBold.copyWith(color: AppColors.textBlack) : AppTypography.bodyRegular.copyWith(color: AppColors.textDisabled);

    return Semantics(
      button: true,
      selected: isSelected,
      enabled: isSelected || isEnabled,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.low,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          child: InkWell(
            onTap: isSelected || isEnabled ? onTap : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            child: Container(
              height: 40,
              constraints: BoxConstraints(minWidth: minWidth),
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              alignment: Alignment.center,
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: textStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyRecommendationsContent extends StatelessWidget {
  const _EmptyRecommendationsContent({
    required this.showBanner,
    required this.onDismissBanner,
    required this.onEditPreferences,
  });

  final bool showBanner;
  final VoidCallback onDismissBanner;
  final VoidCallback onEditPreferences;

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: [
        if (showBanner) ...[
          _NoRecommendationsBanner(
            onDismiss: onDismissBanner,
            onEditPreferences: onEditPreferences,
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
        _PreferencesHint(onEditPreferences: onEditPreferences),
      ],
    );
  }
}

class _PreferencesHint extends StatelessWidget {
  const _PreferencesHint({required this.onEditPreferences});

  final VoidCallback onEditPreferences;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space4,
        vertical: AppDimensions.space8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIcon(AppIcons.info, color: AppColors.primaryDark),
          const SizedBox(width: AppDimensions.space8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.space4),
              child: Text(
                'Personaliza tus recomendaciones editando tus hechos vitales en Preferencias siempre que quieras.',
                style: AppTypography.smallRegular.copyWith(color: AppColors.primaryDark),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.space16),
          SizedBox(
            width: AppDimensions.minTouchTarget,
            height: AppDimensions.minTouchTarget,
            child: AppIconButton(
              icon: AppIcons.settings,
              onPressed: onEditPreferences,
              hierarchy: AppButtonHierarchy.secondary,
              semanticsLabel: l10n.drawerPreferences,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.recommendation});

  final Recommendation recommendation;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.secondaryLight400),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _RecommendationBadge(badge: recommendation.badge),
          const SizedBox(height: AppDimensions.space12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              recommendation.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.leadingBold.copyWith(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.space8),
            color: AppColors.backgroundLightBlue,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.recommendationsLifeEventPrefix.toUpperCase(),
                  style: AppTypography.captionUppercase.copyWith(color: AppColors.textPrimary),
                ),
                const SizedBox(height: AppDimensions.space4),
                Text(
                  recommendation.lifeEventName,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
                ),
                if (recommendation.responsibleUnit case final responsibleUnit?) ...[
                  const SizedBox(height: AppDimensions.space8),
                  Text(
                    '${l10n.recommendationsResponsibleUnitPrefix} $responsibleUnit',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
                  ),
                ],
                if (_deadlineText(context, recommendation) case final deadline?) ...[
                  const SizedBox(height: AppDimensions.space4),
                  Text(
                    '${l10n.recommendationsDeadlinePrefix} $deadline',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.smallRegular.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationBadge extends StatelessWidget {
  const _RecommendationBadge({required this.badge});

  final RecommendationBadge badge;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (badge) {
      RecommendationBadge.recent => AppTag(
        status: AppTagStatus.warning,
        label: l10n.recommendationsTabRecent,
        icon: AppIcons.hourglass,
      ),
      RecommendationBadge.news => AppTag(
        status: AppTagStatus.infoActive,
        label: l10n.recommendationsTabNew,
        icon: AppIcons.autorenew,
      ),
      RecommendationBadge.immediate => AppTag(
        status: AppTagStatus.success,
        label: l10n.recommendationsImmediateBadge,
        icon: AppIcons.check,
      ),
    };
  }
}

class _NoRecommendationsBanner extends StatelessWidget {
  const _NoRecommendationsBanner({
    required this.onDismiss,
    required this.onEditPreferences,
  });

  final VoidCallback onDismiss;
  final VoidCallback onEditPreferences;

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.backgroundBlueMutedLight,
        border: Border.all(color: AppColors.borderBlueMutedLight),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        boxShadow: AppShadows.high,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 40),
                      child: Row(
                        children: [
                          const AppIcon(AppIcons.info, color: AppColors.blueMuted900),
                          const SizedBox(width: AppDimensions.space8),
                          Expanded(
                            child: Text(
                              'Sin recomendaciones disponibles',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.captionUppercase.copyWith(
                                color: AppColors.blueMuted900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: AppDimensions.space32,
                        top: AppDimensions.space4,
                      ),
                      child: Text(
                        'Ajusta tus preferencias para explorar más opciones o espera a nuevas actualizaciones.',
                        style: AppTypography.bodyRegular.copyWith(color: AppColors.textBlack),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
                height: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const AppIcon(AppIcons.close, color: AppColors.primaryDark),
                  onPressed: onDismiss,
                  tooltip: 'Cerrar',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space4),
          TextButton.icon(
            onPressed: onEditPreferences,
            icon: const AppIcon(AppIcons.settings, color: AppColors.textBlack),
            label: Text(
              'Editar preferencias',
              style: AppTypography.bodyRegular.copyWith(color: AppColors.textBlack),
            ),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textBlack,
              minimumSize: const Size(AppDimensions.minTouchTarget, 40),
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _RecommendationFilter {
  all,
  recent,
  news
  ;

  String label(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      _RecommendationFilter.all => l10n.recommendationsTabAll,
      _RecommendationFilter.recent => l10n.recommendationsTabRecent,
      _RecommendationFilter.news => l10n.recommendationsTabNew,
    };
  }

  List<Recommendation> apply(final List<Recommendation> recommendations) {
    return switch (this) {
      _RecommendationFilter.all => recommendations,
      _RecommendationFilter.recent => recommendations.where((final rec) => rec.badge == RecommendationBadge.recent).toList(growable: false),
      _RecommendationFilter.news => recommendations.where((final rec) => rec.badge == RecommendationBadge.news).toList(growable: false),
    };
  }
}

String? _deadlineText(final BuildContext context, final Recommendation recommendation) {
  final start = recommendation.submissionStartDate;
  final end = recommendation.submissionEndDate;
  if (start == null && end == null) {
    return null;
  }
  if (start != null && end != null) {
    return '${_formatShortDate(start)} - ${_formatShortDate(end)}';
  }
  if (start != null) {
    return 'desde ${_formatShortDate(start)}';
  }
  return 'hasta ${_formatShortDate(end!)}';
}

String _formatShortDate(final DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
