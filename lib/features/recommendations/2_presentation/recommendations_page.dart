import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendation_life_event_filters_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationsPage extends ConsumerStatefulWidget {
  const RecommendationsPage({super.key});

  @override
  ConsumerState<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends ConsumerState<RecommendationsPage> {
  _RecommendationFilter _selectedFilter = _RecommendationFilter.all;
  Set<int>? _selectedLifeEventFilterIds;
  bool _showNoRecommendationsBanner = true;

  void _goToPreferences() {
    unawaited(context.push(Routes.preferences));
  }

  Future<void> _openLifeEventFilters(final RecommendationsState state) async {
    final events = state.selectedLifeEventOptions;
    if (events.isEmpty) {
      return;
    }

    final selectedIds = await context.push<Set<int>>(
      Routes.recommendationLifeEventFilters,
      extra: RecommendationLifeEventFiltersArgs(
        events: events,
        selectedIds: _selectedLifeEventFilterIds ?? const {},
      ),
    );
    if (!mounted || selectedIds == null) {
      return;
    }
    setState(() {
      _selectedLifeEventFilterIds = selectedIds;
      if (selectedIds.isEmpty) {
        _selectedFilter = _RecommendationFilter.all;
      }
    });
  }

  List<Recommendation> _filterByLifeEvents({
    required final List<Recommendation> recommendations,
    required final List<RecommendationLifeEventOption> events,
  }) {
    final selectedIds = _selectedLifeEventFilterIds;
    if (selectedIds == null) {
      return recommendations;
    }
    if (selectedIds.isEmpty) {
      return const [];
    }
    final availableIds = events.map((final event) => event.id).toSet();
    final activeIds = selectedIds.intersection(availableIds);
    if (activeIds.isEmpty) {
      return recommendations;
    }
    return recommendations.where((final recommendation) => activeIds.contains(recommendation.lifeEventId)).toList(growable: false);
  }

  int _activeLifeEventFilterCount(final List<RecommendationLifeEventOption> events) {
    final selectedIds = _selectedLifeEventFilterIds;
    if (selectedIds == null || selectedIds.isEmpty) {
      return 0;
    }
    final availableIds = events.map((final event) => event.id).toSet();
    return selectedIds.intersection(availableIds).length;
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
    );
  }

  Widget _buildLoadedContent(final BuildContext context, final RecommendationsState state) {
    final lifeEventFilteredRecommendations = _filterByLifeEvents(
      recommendations: state.recommendations,
      events: state.selectedLifeEventOptions,
    );
    final recommendations = _selectedFilter.apply(lifeEventFilteredRecommendations);
    final showLifeEventsFilterButton = state.hasLifeEventsConsent && state.hasConfiguredLifeEvents;
    final showNoRecommendationsBanner = state.hasLifeEventsConsent && state.hasConfiguredLifeEvents && recommendations.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          recommendations: lifeEventFilteredRecommendations,
          onSelected: (final filter) => setState(() => _selectedFilter = filter),
        ),
        const SizedBox(height: AppDimensions.space24),
        if (showLifeEventsFilterButton) ...[
          AppFilterButton(
            label: 'Filtrar por hechos vitales',
            activeFilterCount: _activeLifeEventFilterCount(state.selectedLifeEventOptions),
            onPressed: () => _openLifeEventFilters(state),
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
        if (showNoRecommendationsBanner) ...[
          if (_showNoRecommendationsBanner) ...[
            _NoRecommendationsBanner(
              onDismiss: () => setState(() => _showNoRecommendationsBanner = false),
              onEditPreferences: _goToPreferences,
            ),
            const SizedBox(height: AppDimensions.space24),
          ],
        ],
        _PreferencesHint(onEditPreferences: _goToPreferences),
        if (recommendations.isNotEmpty) ...[
          const SizedBox(height: AppDimensions.space24),
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
          recommendations: const [],
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
          recommendations: const [],
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

class _FilterNavigation extends StatefulWidget {
  const _FilterNavigation({
    required this.selectedFilter,
    required this.recommendations,
    this.onSelected,
  });

  final _RecommendationFilter selectedFilter;
  final List<Recommendation> recommendations;
  final ValueChanged<_RecommendationFilter>? onSelected;

  @override
  State<_FilterNavigation> createState() => _FilterNavigationState();
}

class _FilterNavigationState extends State<_FilterNavigation> {
  static const _primaryFilters = [
    _RecommendationFilter.all,
    _RecommendationFilter.recent,
    _RecommendationFilter.news,
  ];
  static const _immediateFilters = [
    _RecommendationFilter.news,
    _RecommendationFilter.immediate,
  ];

  bool _showImmediate = false;

  @override
  void didUpdateWidget(covariant final _FilterNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFilter == _RecommendationFilter.immediate) {
      _showImmediate = true;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final enabledFilters = {
      _RecommendationFilter.all,
      for (final filter in _RecommendationFilter.values)
        if (filter != _RecommendationFilter.all && filter.apply(widget.recommendations).isNotEmpty) filter,
    };
    final filters = _showImmediate ? _immediateFilters : _primaryFilters;
    final selectedIndex = filters.contains(widget.selectedFilter) ? filters.indexOf(widget.selectedFilter) : filters.indexOf(_RecommendationFilter.news);

    return AppFloatingNavigation(
      tabs: filters.map((final filter) => filter.label(context)).toList(growable: false),
      selectedIndex: selectedIndex,
      enabledTabs: filters.map(enabledFilters.contains).toList(growable: false),
      minTabWidths: _showImmediate ? const [128, 206] : const [76, 150, 150],
      onTabSelected: (final index) => widget.onSelected?.call(filters[index]),
      leading: _showImmediate
          ? _FloatingNavigationArrow(
              icon: AppIcons.arrowBack,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => setState(() => _showImmediate = false),
            )
          : null,
      trailing: !_showImmediate
          ? _FloatingNavigationArrow(
              icon: AppIcons.arrowForward,
              tooltip: _RecommendationFilter.immediate.label(context),
              onPressed: () => setState(() => _showImmediate = true),
            )
          : null,
    );
  }
}

class _FloatingNavigationArrow extends StatelessWidget {
  const _FloatingNavigationArrow({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      width: AppDimensions.minTouchTarget,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: AppIcon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
        tooltip: tooltip,
      ),
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
    final responsibleUnit = recommendation.responsibleUnit;
    final deadline = _deadlineText(context, recommendation);
    return AppRecommendationCard(
      title: recommendation.title,
      badge: _RecommendationBadge(badge: recommendation.badge),
      detailLabel: l10n.recommendationsAssociatedLifeEventsLabel,
      detailText: recommendation.lifeEventName,
      responsibleUnitText: responsibleUnit == null ? null : '${l10n.recommendationsResponsibleUnitPrefix} $responsibleUnit',
      deadlineText: deadline == null ? null : '${l10n.recommendationsDeadlinePrefix} $deadline',
      onTap: () => unawaited(_openRecommendationDetail(context, recommendation)),
    );
  }
}

Future<void> _openRecommendationDetail(
  final BuildContext context,
  final Recommendation recommendation,
) async {
  final l10n = AppLocalizations.of(context);
  final url = recommendation.detailUrl;
  if (url == null || !url.hasScheme) {
    AppAlertSnackbar.show(context, message: l10n.recommendationsDetailUnavailable);
    return;
  }

  final accepted = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!context.mounted || accepted) {
    return;
  }
  AppAlertSnackbar.show(context, message: l10n.externalLinkOpenFailed);
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
        showIcon: false,
      ),
      RecommendationBadge.news => AppTag(
        status: AppTagStatus.infoActive,
        label: l10n.recommendationsTabNew,
        icon: AppIcons.autorenew,
        showIcon: false,
      ),
      RecommendationBadge.immediate => AppTag(
        status: AppTagStatus.success,
        label: l10n.recommendationsImmediateBadge,
        icon: AppIcons.check,
        showIcon: false,
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
    return AppAlertBanner(
      title: 'Sin recomendaciones disponibles',
      message: 'Ajusta tus preferencias para explorar más opciones o espera a nuevas actualizaciones.',
      onDismiss: onDismiss,
      action: AppButton(
        label: 'Editar preferencias',
        onPressed: onEditPreferences,
        hierarchy: AppButtonHierarchy.tertiary,
        size: AppButtonSize.small,
        leadingIcon: AppIcons.settings,
      ),
    );
  }
}

enum _RecommendationFilter {
  all,
  recent,
  news,
  immediate;

  String label(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (this) {
      _RecommendationFilter.all => l10n.recommendationsTabAll,
      _RecommendationFilter.recent => l10n.recommendationsTabRecent,
      _RecommendationFilter.news => l10n.recommendationsTabNew,
      _RecommendationFilter.immediate => l10n.recommendationsTabImmediate,
    };
  }

  List<Recommendation> apply(final List<Recommendation> recommendations) {
    return switch (this) {
      _RecommendationFilter.all => recommendations,
      _RecommendationFilter.recent => recommendations.where((final rec) => rec.badge == RecommendationBadge.recent).toList(growable: false),
      _RecommendationFilter.news => recommendations.where((final rec) => rec.badge == RecommendationBadge.news).toList(growable: false),
      _RecommendationFilter.immediate => recommendations.where((final rec) => rec.badge == RecommendationBadge.immediate).toList(growable: false),
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
