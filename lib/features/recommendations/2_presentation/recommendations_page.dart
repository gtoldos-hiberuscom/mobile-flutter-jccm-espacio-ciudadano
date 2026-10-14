import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/core/design_system/design_system.dart';
import 'package:jccm_espacio_ciudadano/core/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/features/auth/2_presentation/widgets/authenticated_profile_menu.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/2_presentation/external_navigation_confirmation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendation.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_repository.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/providers/recommendations_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/recommendation_life_event_filters_page.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

class RecommendationsPage extends ConsumerStatefulWidget {
  const RecommendationsPage({super.key});

  @override
  ConsumerState<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends ConsumerState<RecommendationsPage> {
  _RecommendationFilter _selectedFilter = _RecommendationFilter.all;
  Set<int>? _selectedLifeEventFilterIds;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((final _) {
      if (mounted) {
        ref.invalidate(recommendationsProvider(RecommendationsSegment.all));
      }
    });
  }

  void _selectRecommendationFilter(final _RecommendationFilter filter) {
    if (_selectedFilter == filter) {
      return;
    }
    setState(() => _selectedFilter = filter);
    ref.invalidate(recommendationsProvider(filter.segment));
  }

  void _resetRecommendationFilters() {
    setState(() {
      _selectedFilter = _RecommendationFilter.all;
      _selectedLifeEventFilterIds = null;
    });
    ref.invalidate(recommendationsProvider(_selectedFilter.segment));
  }

  Future<void> _openLifeEvents() async {
    await context.push<void>(
      Uri(
        path: Routes.lifeEvents,
        queryParameters: const {'returnTo': Routes.recommendations},
      ).toString(),
    );
    if (mounted) {
      ref.invalidate(recommendationsProvider(_selectedFilter.segment));
    }
  }

  Future<void> _reviewConsents() async {
    await context.push<void>(
      Uri(
        path: Routes.consent,
        queryParameters: const {
          'mode': 'preferences',
          'returnTo': Routes.recommendations,
        },
      ).toString(),
    );
    if (mounted) {
      ref.invalidate(recommendationsProvider(_selectedFilter.segment));
    }
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
    ref.invalidate(recommendationsProvider(_selectedFilter.segment));
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
    final state = ref.watch(recommendationsProvider(_selectedFilter.segment));

    return Scaffold(
      appBar: AppNavBar(
        title: l10n.recommendationsTitle,
        isLoggedIn: true,
        showNotifications: false,
        profileInitials: authenticatedProfileInitials(ref),
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
              padding: appPagePadding(context, top: AppDimensions.space24, bottom: AppDimensions.space24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > AppDimensions.space48 ? constraints.maxHeight - AppDimensions.space48 : 0,
                ),
                child: state.when(
                  data: (final data) => _buildLoadedContent(context, data),
                  loading: _buildLoadingContent,
                  error: (final error, final stackTrace) => _buildErrorContent(context),
                  skipLoadingOnRefresh: false,
                  skipLoadingOnReload: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadedContent(final BuildContext context, final RecommendationsState state) {
    if (!state.hasLifeEventsConsent) {
      return _RecommendationsAuthorizationRequired(
        onReviewConsents: () => unawaited(_reviewConsents()),
      );
    }

    final lifeEventFilteredRecommendations = _filterByLifeEvents(
      recommendations: state.recommendations,
      events: state.selectedLifeEventOptions,
    );
    final recommendations = lifeEventFilteredRecommendations;
    final hasRecommendations = state.recommendations.isNotEmpty;
    final hasActiveFilters = _selectedFilter != _RecommendationFilter.all || _selectedLifeEventFilterIds != null;
    final showNoRecommendationsHelper = _selectedFilter == _RecommendationFilter.all && state.hasLifeEventsConsent && !hasRecommendations;
    final showNoFilteredRecommendationsHelper = hasActiveFilters && recommendations.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LifeEventsFilterControls(
          activeFilterCount: _activeLifeEventFilterCount(
            state.selectedLifeEventOptions,
          ),
          onFilter: state.hasConfiguredLifeEvents && state.recommendations.isNotEmpty ? () => unawaited(_openLifeEventFilters(state)) : null,
          onEditLifeEvents: () => unawaited(_openLifeEvents()),
        ),
        const SizedBox(height: AppDimensions.space24),
        _FilterNavigation(
          selectedFilter: _selectedFilter,
          onSelected: _selectRecommendationFilter,
        ),
        const SizedBox(height: AppDimensions.space24),
        if (showNoRecommendationsHelper) ...[
          _NoRecommendationsContextualHelper(
            onEditLifeEvents: () => unawaited(_openLifeEvents()),
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
        if (showNoFilteredRecommendationsHelper) ...[
          _NoFilteredRecommendationsContextualHelper(
            onResetFilters: _resetRecommendationFilters,
          ),
          const SizedBox(height: AppDimensions.space24),
        ],
        if (recommendations.isNotEmpty) ...[
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
          onSelected: _selectRecommendationFilter,
        ),
        const SizedBox(height: AppDimensions.space16),
        _LifeEventsFilterControls(
          activeFilterCount: 0,
          onFilter: null,
          onEditLifeEvents: () => unawaited(_openLifeEvents()),
        ),
        const SizedBox(height: AppDimensions.space24),
        // Mismo tratamiento visual que el error de servicio de "Mis datos":
        // aviso contextual con la acción de recarga dentro, en vez de un título
        // suelto con un botón primario debajo.
        AppAlertContextual(
          message: l10n.recommendationsLoadingError,
          action: AppButton(
            label: l10n.recommendationsLoadingErrorRetry,
            hierarchy: AppButtonHierarchy.ghost,
            size: AppButtonSize.small,
            trailingIcon: AppIcons.autorenew,
            onPressed: () => ref.invalidate(recommendationsProvider(_selectedFilter.segment)),
          ),
        ),
      ],
    );
  }
}

class _LifeEventsFilterControls extends StatelessWidget {
  const _LifeEventsFilterControls({
    required this.activeFilterCount,
    required this.onFilter,
    required this.onEditLifeEvents,
  });

  final int activeFilterCount;
  final VoidCallback? onFilter;
  final VoidCallback? onEditLifeEvents;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        Expanded(
          child: AppFilterButton(
            label: l10n.recommendationsFilterByLifeEvents,
            activeFilterCount: activeFilterCount,
            onPressed: onFilter,
          ),
        ),
        const SizedBox(width: AppDimensions.space16),
        AppIconButton(
          icon: AppIcons.settings,
          onPressed: onEditLifeEvents,
          hierarchy: AppButtonHierarchy.secondary,
          semanticsLabel: l10n.lifeEventsTitle,
        ),
      ],
    );
  }
}

class _RecommendationsAuthorizationRequired extends StatelessWidget {
  const _RecommendationsAuthorizationRequired({required this.onReviewConsents});

  final VoidCallback onReviewConsents;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _FilterNavigation(
          selectedFilter: _RecommendationFilter.all,
        ),
        const SizedBox(height: AppDimensions.space16),
        const _LifeEventsFilterControls(
          activeFilterCount: 0,
          onFilter: null,
          onEditLifeEvents: null,
        ),
        const SizedBox(height: AppDimensions.space24),
        AppAlertContextual(
          message: l10n.myDataJccmAuthorizationRequiredMessage,
          action: AppButton(
            label: l10n.myDataJccmAuthorizationRequiredCta,
            onPressed: onReviewConsents,
            hierarchy: AppButtonHierarchy.ghost,
            size: AppButtonSize.small,
            trailingIcon: AppIcons.callMade,
          ),
        ),
      ],
    );
  }
}

class _FilterNavigation extends StatefulWidget {
  const _FilterNavigation({
    required this.selectedFilter,
    this.onSelected,
  });

  final _RecommendationFilter selectedFilter;
  final ValueChanged<_RecommendationFilter>? onSelected;

  @override
  State<_FilterNavigation> createState() => _FilterNavigationState();
}

class _FilterNavigationState extends State<_FilterNavigation> {
  static const _swipeDistanceThreshold = 48.0;
  static const _swipeVelocityThreshold = 200.0;
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
  double _horizontalDragDistance = 0;

  @override
  void initState() {
    super.initState();
    _showImmediate = widget.selectedFilter == _RecommendationFilter.immediate;
  }

  @override
  void didUpdateWidget(covariant final _FilterNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFilter == _RecommendationFilter.immediate) {
      _showImmediate = true;
    }
  }

  void _onHorizontalDragStart(final DragStartDetails _) {
    _horizontalDragDistance = 0;
  }

  void _onHorizontalDragUpdate(final DragUpdateDetails details) {
    _horizontalDragDistance += details.delta.dx;
  }

  void _onHorizontalDragEnd(final DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final swipedLeft = _horizontalDragDistance <= -_swipeDistanceThreshold || velocity <= -_swipeVelocityThreshold;
    final swipedRight = _horizontalDragDistance >= _swipeDistanceThreshold || velocity >= _swipeVelocityThreshold;

    if (!_showImmediate && swipedLeft) {
      setState(() => _showImmediate = true);
    } else if (_showImmediate && swipedRight) {
      setState(() => _showImmediate = false);
    }
    _horizontalDragDistance = 0;
  }

  @override
  Widget build(final BuildContext context) {
    // En tablet caben los cuatro filtros. Con el texto ampliado también se
    // muestran todos, repartidos en varias líneas: así ninguno exige deslizar
    // ni pulsar una flecha para alcanzarlo (WCAG 2.5.1).
    final showsAllFilters = isTabletLayout(context) || MediaQuery.textScalerOf(context).scale(1) > 1.5;
    if (showsAllFilters) {
      const filters = _RecommendationFilter.values;
      return AppFloatingNavigation(
        tabs: filters.map((final filter) => filter.label(context)).toList(growable: false),
        selectedIndex: filters.indexOf(widget.selectedFilter),
        tabHorizontalPadding: AppDimensions.space16,
        onTabSelected: (final index) => widget.onSelected?.call(filters[index]),
      );
    }

    final filters = _showImmediate ? _immediateFilters : _primaryFilters;
    final selectedIndex = filters.indexOf(widget.selectedFilter);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        transitionBuilder: (final child, final animation) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.12, 0), end: Offset.zero).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: AppFloatingNavigation(
          key: ValueKey(_showImmediate),
          tabs: filters.map((final filter) => filter.label(context)).toList(growable: false),
          selectedIndex: selectedIndex,
          // Cada grupo es una vista parcial de los cuatro filtros: la posición
          // anunciada se refiere al conjunto completo (4.1.2).
          tabPositions: filters.map((final filter) => filter.index + 1).toList(growable: false),
          semanticTabCount: _RecommendationFilter.values.length,
          enabledTabs: List<bool>.filled(filters.length, true),
          minTabWidths: List<double>.filled(filters.length, 40),
          tabMinHeight: AppDimensions.space40,
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
        ),
      ),
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
      child: AppFocusRing(
        borderRadius: const BorderRadius.all(Radius.circular(AppDimensions.radiusRound)),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: AppIcon(icon, color: AppColors.textPrimary),
          onPressed: onPressed,
          tooltip: tooltip,
        ),
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
    final deadline = _deadlineText(context, recommendation);
    return AppRecommendationCard(
      title: recommendation.title,
      categoryLabels: _categoryLabels(context, recommendation.badges),
      detailLabel: l10n.recommendationsAssociatedLifeEventsLabel,
      detailText: recommendation.lifeEventName,
      statusText: recommendation.submissionStatusText ?? deadline,
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

  await launchExternalUrlWithConfirmation(context, url);
}

List<String> _categoryLabels(
  final BuildContext context,
  final Set<RecommendationBadge> badges,
) {
  final l10n = AppLocalizations.of(context);
  return [
    if (badges.contains(RecommendationBadge.recent)) l10n.recommendationsTabRecent,
    if (badges.contains(RecommendationBadge.news)) l10n.recommendationsTabNew,
    if (badges.contains(RecommendationBadge.immediate)) l10n.recommendationsImmediateBadge,
  ];
}

class _NoRecommendationsContextualHelper extends StatelessWidget {
  const _NoRecommendationsContextualHelper({
    required this.onEditLifeEvents,
  });

  final VoidCallback onEditLifeEvents;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppAlertContextual(
      size: AppAlertContextualSize.small,
      message: l10n.recommendationsEmptyNoMatches,
      actionSpacing: AppDimensions.space4,
      action: AppButton(
        label: l10n.recommendationsEditLifeEventsCta,
        onPressed: onEditLifeEvents,
        hierarchy: AppButtonHierarchy.ghost,
        size: AppButtonSize.small,
        trailingIcon: AppIcons.callMade,
      ),
    );
  }
}

class _NoFilteredRecommendationsContextualHelper extends StatelessWidget {
  const _NoFilteredRecommendationsContextualHelper({
    required this.onResetFilters,
  });

  final VoidCallback onResetFilters;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppAlertContextual(
      size: AppAlertContextualSize.small,
      message: l10n.recommendationsEmptyFiltered,
      actionSpacing: AppDimensions.space4,
      action: AppButton(
        label: l10n.recommendationsResetFilterCta,
        onPressed: onResetFilters,
        hierarchy: AppButtonHierarchy.ghost,
        size: AppButtonSize.small,
        leadingIcon: AppIcons.autorenew,
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

  RecommendationsSegment get segment {
    return switch (this) {
      _RecommendationFilter.all => RecommendationsSegment.all,
      _RecommendationFilter.recent => RecommendationsSegment.recent,
      _RecommendationFilter.news => RecommendationsSegment.news,
      _RecommendationFilter.immediate => RecommendationsSegment.immediate,
    };
  }
}

String? _deadlineText(final BuildContext context, final Recommendation recommendation) {
  final l10n = AppLocalizations.of(context);
  final start = recommendation.submissionStartDate;
  final end = recommendation.submissionEndDate;
  if (start == null && end == null) {
    return null;
  }
  if (start != null && end != null) {
    return '${_formatShortDate(start)} - ${_formatShortDate(end)}';
  }
  if (start != null) {
    return l10n.recommendationsDeadlineFrom(_formatShortDate(start));
  }
  return l10n.recommendationsDeadlineUntil(_formatShortDate(end!));
}

String _formatShortDate(final DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
