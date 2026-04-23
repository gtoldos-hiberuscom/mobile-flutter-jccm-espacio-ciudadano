import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jccm_espacio_ciudadano/app/routing/route_registry.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_colors.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_provider.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/error_state_widget.dart';
import 'package:jccm_espacio_ciudadano/core/ui_states/loading_state_widget.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_block_id.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_dashboard_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/home/0_entity/home_widget_summary.dart';
import 'package:jccm_espacio_ciudadano/features/home/1_domain/home_dashboard_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/home/2_presentation/widgets/home_block_card.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/0_entity/user_profile.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/1_domain/user_profile_notifier.dart';
import 'package:jccm_espacio_ciudadano/features/user_profile/2_presentation/widgets/user_header_widget.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Authenticated home dashboard.
///
/// Replaces the legacy `HomePlaceholder`. Composes:
/// - the personalised greeting via [UserHeaderWidget],
/// - the citizen identifier (idAgente),
/// - one [HomeBlockCard] per [HomeBlockId] (thematic landings + personal
///   widgets), each card hydrated independently so that one block failing
///   does not prevent the rest of the home from rendering (canon §16).
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final dashboardAsync = ref.watch(homeDashboardProvider);
    final profileAsync = ref.watch(userProfileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(homeDashboardProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Greeting(profileAsync: profileAsync),
              ),
              dashboardAsync.when(
                data: (final snapshot) => SliverList.list(
                  children: _buildBlockCards(context, ref, snapshot, l10n),
                ),
                loading: () => const SliverFillRemaining(
                  hasScrollBody: false,
                  child: LoadingStateWidget(),
                ),
                error: (final err, final _) => SliverFillRemaining(
                  hasScrollBody: false,
                  child: ErrorStateWidget(
                    message: l10n.errorStateDefault,
                    onRetry: () => ref
                        .read(homeDashboardProvider.notifier)
                        .refresh(),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.space24),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBlockCards(
    final BuildContext context,
    final WidgetRef ref,
    final HomeDashboardSnapshot snapshot,
    final AppLocalizations l10n,
  ) {
    return [
      for (final block in snapshot.blocks)
        HomeBlockCard(
          key: ValueKey(block.blockId),
          title: _titleFor(block.blockId, l10n),
          summary: block,
          icon: _iconFor(block.blockId),
          onTap: () => _onBlockTap(context, ref, block),
          onRetry: () =>
              ref.read(homeDashboardProvider.notifier).refresh(),
        ),
    ];
  }

  void _onBlockTap(
    final BuildContext context,
    final WidgetRef ref,
    final HomeWidgetSummary block,
  ) {
    final route = _routeFor(block.blockId);
    ref.read(analyticsServiceProvider).logEvent(
          HomeBlockNavigateEvent(block.blockId.name, target: route),
        );
    context.go(route);
  }

  String _titleFor(final HomeBlockId id, final AppLocalizations l10n) {
    switch (id) {
      case HomeBlockId.education:
        return l10n.homeBlockEducationTitle;
      case HomeBlockId.employment:
        return l10n.homeBlockEmploymentTitle;
      case HomeBlockId.socialWelfare:
        return l10n.homeBlockSocialWelfareTitle;
      case HomeBlockId.stateAffairs:
        return l10n.homeBlockStateAffairsTitle;
      case HomeBlockId.agenda:
        return l10n.homeBlockAgendaTitle;
      case HomeBlockId.upcomingEvents:
        return l10n.homeBlockUpcomingEventsTitle;
      case HomeBlockId.casework:
        return l10n.homeBlockCaseworkTitle;
      case HomeBlockId.notifications:
        return l10n.homeBlockNotificationsTitle;
      case HomeBlockId.digitalCards:
        return l10n.homeBlockDigitalCardsTitle;
      case HomeBlockId.recommendations:
        return l10n.homeBlockRecommendationsTitle;
    }
  }

  IconData _iconFor(final HomeBlockId id) {
    switch (id) {
      case HomeBlockId.education:
        return Icons.school_outlined;
      case HomeBlockId.employment:
        return Icons.work_outline;
      case HomeBlockId.socialWelfare:
        return Icons.volunteer_activism_outlined;
      case HomeBlockId.stateAffairs:
        return Icons.account_balance_outlined;
      case HomeBlockId.agenda:
        return Icons.event_outlined;
      case HomeBlockId.upcomingEvents:
        return Icons.schedule_outlined;
      case HomeBlockId.casework:
        return Icons.folder_outlined;
      case HomeBlockId.notifications:
        return Icons.notifications_outlined;
      case HomeBlockId.digitalCards:
        return Icons.credit_card_outlined;
      case HomeBlockId.recommendations:
        return Icons.recommend_outlined;
    }
  }

  String _routeFor(final HomeBlockId id) {
    switch (id) {
      case HomeBlockId.education:
        return Routes.education;
      case HomeBlockId.employment:
        return Routes.employment;
      case HomeBlockId.socialWelfare:
        return Routes.socialWelfare;
      case HomeBlockId.stateAffairs:
        return Routes.stateAffairs;
      case HomeBlockId.agenda:
      case HomeBlockId.upcomingEvents:
        return Routes.agenda;
      case HomeBlockId.casework:
        return Routes.casework;
      case HomeBlockId.notifications:
        return Routes.notifications;
      case HomeBlockId.digitalCards:
        return Routes.cards;
      case HomeBlockId.recommendations:
        return Routes.recommendations;
    }
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profileAsync});

  final AsyncValue<UserProfile?> profileAsync;

  @override
  Widget build(final BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final profile = profileAsync.value;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space16,
        AppDimensions.space8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile != null)
            UserHeaderWidget(profile: profile)
          else
            Text(
              l10n.homeGreetingFallback,
              style: theme.textTheme.titleMedium,
            ),
          if (profile != null) ...[
            const SizedBox(height: AppDimensions.space4),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.space8),
              child: Text(
                l10n.homeCitizenId(profile.idAgente),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
