import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/core/extensions/date_time_format.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/empty_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/paginated_list_view.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_event.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_period_filter.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/0_entity/agenda_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/1_domain/agenda_state.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_event_tile.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/agenda_month_calendar.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/cip_card.dart';
import 'package:jccm_espacio_ciudadano/features/agenda/2_presentation/widgets/upcoming_events_summary.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Agenda surface (STORY-29).
///
/// Layout:
///  - App bar with the page title and the last-updated timestamp.
///  - Segmented chips for [AgendaPeriodFilter].
///  - Tab toggle "Lista" / "Calendario".
///  - Body: paginated list, or monthly calendar + filtered list.
///
/// All copy goes through ARB; design tokens come from
/// [AppDimensions] / [Theme]. Analytics emits
/// [AgendaPeriodChangedEvent] and [AgendaEventOpenedEvent].
class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

enum _AgendaViewMode { list, calendar }

class _AgendaPageState extends ConsumerState<AgendaPage> {
  static const int _pageSize = 10;

  _AgendaViewMode _viewMode = _AgendaViewMode.list;
  int _visibleCount = _pageSize;

  void _resetPagination() => setState(() => _visibleCount = _pageSize);

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(agendaProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.agendaPageTitle),
        actions: [
          asyncState.maybeWhen(
            data: (final s) => Padding(
              padding: const EdgeInsets.only(right: AppDimensions.space12),
              child: Center(
                child: Text(
                  l10n.agendaLastUpdated(
                    s.snapshot.lastUpdatedAt.formatDdMmYyyyHhMm(),
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final err, final st) => ErrorStateWidget(
          message: l10n.agendaError,
          onRetry: () =>
              ref.read(agendaProvider.notifier).refresh(),
        ),
        data: (final s) {
          // Parse-error → recoverable surface with explicit "intentar de
          // nuevo" CTA. Never expose the raw reason (canon §24).
          if (s.snapshot.loadState == AgendaLoadState.parseError) {
            return ErrorStateWidget(
              key: const ValueKey('agenda-parse-error'),
              message: l10n.agendaParseErrorTitle,
              detail: l10n.agendaParseErrorDetail,
              retryLabel: l10n.agendaParseErrorRetry,
              onRetry: () =>
                  ref.read(agendaProvider.notifier).refresh(),
            );
          }
          return _buildBody(context, s, l10n);
        },
      ),
    );
  }

  Widget _buildBody(
    final BuildContext context,
    final AgendaState state,
    final AppLocalizations l10n,
  ) {
    final now = DateTime.now();
    final visible = state.visibleEvents(now);
    final pageItems = visible.take(_visibleCount).toList(growable: false);
    final hasMore = visible.length > _visibleCount;

    return Column(
      children: [
        if (state.snapshot.loadState == AgendaLoadState.partial)
          _PartialBanner(message: l10n.agendaPartialBanner),
        // STORY-31 — sticky CIP read-only card at the top of the agenda
        // header. Per TASK-71 (CIP_REUSE) this is the single, non-wallet
        // CIP rendering shared with the home salud entry point.
        const CipCard(),
        // STORY-31 AC2 — reuse the home upcoming events summary inside
        // the agenda header so both surfaces stay in sync.
        UpcomingEventsSummary(
          snapshot: state.snapshot,
          now: now,
          onEventTap: (final event) {
            ref.read(analyticsServiceProvider).logEvent(
                  AgendaEventOpenedEvent(
                    eventId: event.id,
                    category: event.category.name,
                  ),
                );
            context.go('/agenda/${event.id}');
          },
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space8,
          ),
          child: _PeriodFilterBar(
            selected: state.period,
            onChanged: (final period) {
              ref
                  .read(analyticsServiceProvider)
                  .logEvent(AgendaPeriodChangedEvent(periodId: period.name));
              ref.read(agendaProvider.notifier).setPeriod(period);
              _resetPagination();
            },
          ),
        ),
        _ViewModeToggle(
          value: _viewMode,
          onChanged: (final mode) => setState(() => _viewMode = mode),
        ),
        const Divider(height: 1),
        Expanded(
          child: _viewMode == _AgendaViewMode.list
              ? _buildListView(context, state, pageItems, hasMore, l10n)
              : _buildCalendarView(context, state, pageItems, l10n),
        ),
      ],
    );
  }

  Widget _buildListView(
    final BuildContext context,
    final AgendaState state,
    final List<AgendaEvent> pageItems,
    final bool hasMore,
    final AppLocalizations l10n,
  ) =>
      PaginatedListView<AgendaEvent>(
        items: pageItems,
        hasMore: hasMore,
        onLoadMore: () =>
            setState(() => _visibleCount += _pageSize),
        onRefresh: () async {
          await ref.read(agendaProvider.notifier).refresh();
          _resetPagination();
        },
        emptyState: EmptyStateWidget(message: l10n.agendaEmpty),
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.space8),
        itemBuilder: (final context, final event, final index) =>
            AgendaEventTile(
          event: event,
          subtitle: event.startsAt.formatDdMmYyyyHhMm(),
          onTap: () {
            ref.read(analyticsServiceProvider).logEvent(
                  AgendaEventOpenedEvent(
                    eventId: event.id,
                    category: event.category.name,
                  ),
                );
            context.go('/agenda/${event.id}');
          },
        ),
      );

  Widget _buildCalendarView(
    final BuildContext context,
    final AgendaState state,
    final List<AgendaEvent> pageItems,
    final AppLocalizations l10n,
  ) =>
      ListView(
        padding: const EdgeInsets.all(AppDimensions.space12),
        children: [
          AgendaMonthCalendar(
            month: state.calendarMonth,
            daysWithEvents: state.daysWithEvents(),
            selectedDay: state.selectedDay,
            onDaySelected: (final day) {
              ref.read(agendaProvider.notifier).selectDay(day);
              _resetPagination();
            },
            onPreviousMonth: () {
              final prev = DateTime(
                state.calendarMonth.year,
                state.calendarMonth.month - 1,
              );
              ref.read(agendaProvider.notifier).setMonth(prev);
              _resetPagination();
            },
            onNextMonth: () {
              final next = DateTime(
                state.calendarMonth.year,
                state.calendarMonth.month + 1,
              );
              ref.read(agendaProvider.notifier).setMonth(next);
              _resetPagination();
            },
          ),
          if (state.selectedDay != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  ref
                      .read(agendaProvider.notifier)
                      .clearSelectedDay();
                  _resetPagination();
                },
                icon: const Icon(Icons.clear),
                label: Text(l10n.agendaClearDay),
              ),
            ),
          const SizedBox(height: AppDimensions.space8),
          if (pageItems.isEmpty)
            EmptyStateWidget(message: l10n.agendaEmpty)
          else
            ...pageItems.map(
              (final event) => AgendaEventTile(
                event: event,
                subtitle: event.startsAt.formatDdMmYyyyHhMm(),
                onTap: () {
                  ref.read(analyticsServiceProvider).logEvent(
                        AgendaEventOpenedEvent(
                          eventId: event.id,
                          category: event.category.name,
                        ),
                      );
                  context.go('/agenda/${event.id}');
                },
              ),
            ),
        ],
      );
}

class _PeriodFilterBar extends StatelessWidget {
  const _PeriodFilterBar({required this.selected, required this.onChanged});

  final AgendaPeriodFilter selected;
  final ValueChanged<AgendaPeriodFilter> onChanged;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String labelFor(final AgendaPeriodFilter p) {
      switch (p) {
        case AgendaPeriodFilter.all:
          return l10n.agendaFilterAll;
        case AgendaPeriodFilter.next7Days:
          return l10n.agendaFilterNext7Days;
        case AgendaPeriodFilter.next30Days:
          return l10n.agendaFilterNext30Days;
        case AgendaPeriodFilter.next365Days:
          return l10n.agendaFilterNext365Days;
        case AgendaPeriodFilter.past:
          return l10n.agendaFilterPast;
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final p in AgendaPeriodFilter.values) ...[
            ChoiceChip(
              label: Text(labelFor(p)),
              selected: selected == p,
              onSelected: (final isSelected) {
                if (isSelected) {
                  onChanged(p);
                }
              },
            ),
            const SizedBox(width: AppDimensions.space8),
          ],
        ],
      ),
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({required this.value, required this.onChanged});

  final _AgendaViewMode value;
  final ValueChanged<_AgendaViewMode> onChanged;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space12,
        vertical: AppDimensions.space4,
      ),
      child: SegmentedButton<_AgendaViewMode>(
        segments: [
          ButtonSegment(
            value: _AgendaViewMode.list,
            label: Text(l10n.agendaViewList),
            icon: const Icon(Icons.list),
          ),
          ButtonSegment(
            value: _AgendaViewMode.calendar,
            label: Text(l10n.agendaViewCalendar),
            icon: const Icon(Icons.calendar_month),
          ),
        ],
        selected: <_AgendaViewMode>{value},
        onSelectionChanged: (final s) => onChanged(s.first),
      ),
    );
  }
}

/// Non-blocking warning banner shown above the agenda list when the
/// snapshot is in [AgendaLoadState.partial] (STORY-30 / TASK-32).
///
/// Renders the items that did load while signalling that some events
/// were discarded by the parser. Uses the `errorContainer` token of
/// the active theme to stay tonal and accessible (canon §22 / §23).
class _PartialBanner extends StatelessWidget {
  const _PartialBanner({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      key: const ValueKey('agenda-partial-banner'),
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space12,
          vertical: AppDimensions.space8,
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              size: AppDimensions.iconSmall,
              color: theme.colorScheme.onErrorContainer,
            ),
            const SizedBox(width: AppDimensions.space8),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
