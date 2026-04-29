import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_empty_variant.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_controller.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendation_card.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendations_empty_view.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendations_error_view.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendations_loading_view.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// *Mis Recomendaciones* (STORY-56 + STORY-57).
///
/// Renders four tabs (Todos / Últimos días / Novedades / Tramitación
/// inmediata) over the same per-bucket Riverpod controller. Tab bodies
/// auto-load on first visit and append pages on scroll near the end.
///
/// STORY-57 owns the empty-state surface — the page short-circuits to
/// [RecommendationsEmptyView] when the citizen is not yet configured /
/// has not authorised, and per-bucket empty results render the
/// "configured but empty" variant inline. Transitions back into a
/// populated list (e.g. after the citizen completes the consent flow)
/// are handled by invalidating the per-bucket controllers when
/// `recommendationsConfigProvider` flips to
/// [RecommendationsConfigState.configured].
class RecommendationsPage extends ConsumerWidget {
  const RecommendationsPage({super.key});

  static const List<RecommendationBucket> _buckets = [
    RecommendationBucket.todos,
    RecommendationBucket.ultimosDias,
    RecommendationBucket.novedades,
    RecommendationBucket.tramitacionInmediata,
  ];

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // STORY-57 — when the config flips into `configured` (e.g. the user
    // came back from the preferences/consent flow), invalidate every
    // per-bucket controller so the list auto-loads on the next build.
    ref.listen<AsyncValue<RecommendationsConfigState>>(
      recommendationsConfigProvider,
      (final previous, final next) {
        final wasConfigured =
            previous?.value == RecommendationsConfigState.configured;
        final isConfigured =
            next.value == RecommendationsConfigState.configured;
        if (!wasConfigured && isConfigured) {
          for (final bucket in _buckets) {
            ref.invalidate(recommendationsControllerProvider(bucket));
          }
        }
      },
    );

    final asyncConfig = ref.watch(recommendationsConfigProvider);

    return DefaultTabController(
      length: _buckets.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.recommendationsTitle),
          bottom: TabBar(
            isScrollable: true,
            tabs: _buckets
                .map(
                  (final b) => Tab(text: _label(l10n, b)),
                )
                .toList(growable: false),
          ),
        ),
        body: OfflineBanner(
          child: asyncConfig.when(
          loading: () => const RecommendationsLoadingView(),
          error: (final err, final st) => RecommendationsErrorView(
            onRetry: () => ref.invalidate(recommendationsConfigProvider),
            detail: err.toString(),
          ),
          data: (final config) {
            if (config != RecommendationsConfigState.configured) {
              // Onboarding / unauthorised — no point in firing the
              // per-bucket fetches. Render the empty view directly so
              // both the SnackBar fallback and the GoRouter navigation
              // are reachable above the TabBarView surface.
              final variant = RecommendationsEmptyVariant.from(
                config: config,
                bucketHasItems: false,
              );
              return RecommendationsEmptyView(variant: variant);
            }
            return TabBarView(
              children: _buckets
                  .map((final b) => RecommendationsBucketView(bucket: b))
                  .toList(growable: false),
            );
          },
        ),
        ),
      ),
    );
  }

  static String _label(final AppLocalizations l10n, final RecommendationBucket b) {
    switch (b) {
      case RecommendationBucket.todos:
        return l10n.recommendationsTabAll;
      case RecommendationBucket.ultimosDias:
        return l10n.recommendationsTabRecent;
      case RecommendationBucket.novedades:
        return l10n.recommendationsTabNew;
      case RecommendationBucket.tramitacionInmediata:
        return l10n.recommendationsTabImmediate;
    }
  }
}

/// One tab body — owns the scroll listener and the load-more trigger.
@visibleForTesting
class RecommendationsBucketView extends ConsumerStatefulWidget {
  const RecommendationsBucketView({required this.bucket, super.key});

  final RecommendationBucket bucket;

  @override
  ConsumerState<RecommendationsBucketView> createState() =>
      _RecommendationsBucketViewState();
}

class _RecommendationsBucketViewState
    extends ConsumerState<RecommendationsBucketView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(final BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);
    final asyncState = ref.watch(
      recommendationsControllerProvider(widget.bucket),
    );
    final controller = ref.read(
      recommendationsControllerProvider(widget.bucket).notifier,
    );

    return asyncState.when(
      skipLoadingOnRefresh: false,
      skipLoadingOnReload: false,
      loading: () => const RecommendationsLoadingView(),
      error: (final err, final st) => RecommendationsErrorView(
        onRetry: controller.loadInitial,
        detail: err.toString(),
      ),
      data: (final bucketState) {
        if (bucketState.items.isEmpty) {
          // STORY-57 — citizen is configured but the backend returned no
          // matches for this bucket. We pass the page-resolved config
          // explicitly through [RecommendationsEmptyVariant.from] so the
          // truth-table stays in one place even though we know we are
          // on the `configured` branch here.
          final variant = RecommendationsEmptyVariant.from(
            config: RecommendationsConfigState.configured,
            bucketHasItems: false,
          );
          return RecommendationsEmptyView(
            variant: variant,
            onSeeAll: widget.bucket == RecommendationBucket.todos
                ? null
                : () => DefaultTabController.of(context).animateTo(0),
          );
        }
        return NotificationListener<ScrollEndNotification>(
          onNotification: (final notification) {
            final metrics = notification.metrics;
            if (metrics.axis != Axis.vertical) {
              return false;
            }
            // Trigger load-more when within 200px of the bottom.
            if (metrics.pixels >= metrics.maxScrollExtent - 200 &&
                bucketState.hasMore) {
              unawaited(controller.loadMore());
            }
            return false;
          },
          child: ListView.builder(
            itemCount: bucketState.items.length + (bucketState.hasMore ? 1 : 0),
            itemBuilder: (final context, final index) {
              if (index == bucketState.items.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.space16,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () => unawaited(controller.loadMore()),
                      child: Text(l10n.recommendationsLoadMore),
                    ),
                  ),
                );
              }
              return RecommendationCard(
                recommendation: bucketState.items[index],
              );
            },
          ),
        );
      },
    );
  }
}
