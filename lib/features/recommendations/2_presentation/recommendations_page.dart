import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/app/theme/app_dimensions.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_bucket.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_config_provider.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/1_domain/recommendations_controller.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendation_card.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendations_error_view.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/2_presentation/widgets/recommendations_loading_view.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// *Mis Recomendaciones* (STORY-56).
///
/// Renders four tabs (Todos / Últimos días / Novedades / Tramitación
/// inmediata) over the same per-bucket Riverpod controller. Tab bodies
/// auto-load on first visit and append pages on scroll near the end.
///
/// STORY-57 will replace the current empty placeholder with the
/// onboarding / unauthorised variants — the empty-state widget here is
/// intentionally minimal and routed through a single extension point
/// (`_RecommendationsBucketView._buildEmpty`) for that to plug in.
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
        body: asyncConfig.when(
          loading: () => const RecommendationsLoadingView(),
          error: (final err, final st) => RecommendationsErrorView(
            onRetry: () => ref.invalidate(recommendationsConfigProvider),
            detail: err.toString(),
          ),
          data: (final config) {
            // STORY-57 will branch on unconfigured / unauthorised here.
            // STORY-56 simply short-circuits to the empty placeholder.
            if (config != RecommendationsConfigState.configured) {
              return _EmptyPlaceholder(message: l10n.recommendationsEmptyBucket);
            }
            return TabBarView(
              children: _buckets
                  .map((final b) => RecommendationsBucketView(bucket: b))
                  .toList(growable: false),
            );
          },
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
          return _buildEmpty(l10n);
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

  /// STORY-57 extension point — replace this with the onboarding /
  /// unauthorised variants when that story lands.
  Widget _buildEmpty(final AppLocalizations l10n) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppDimensions.space32),
      child: Text(
        l10n.recommendationsEmptyBucket,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({required this.message});

  final String message;

  @override
  Widget build(final BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(AppDimensions.space32),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}
