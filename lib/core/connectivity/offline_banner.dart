import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/core/feature_flags/resilience_flag.dart';
import 'package:jccm_espacio_ciudadano/l10n/app_localizations.dart';

/// Sprint 7 / STORY-65 — opt-in offline banner.
///
/// Renders a slim banner above [child] when [connectivityStatusProvider]
/// reports `offline`. Features adopt by wrapping their list/inbox/feed
/// pages, e.g. agenda, notifications, recommendations.
///
/// The banner is purely advisory — adopters keep showing whatever cached
/// data they have. It does NOT replace error states; transient errors are
/// still surfaced inline by each feature.
///
/// Sprint 9 note — the logged-in home page wrapping is intentionally
/// deferred. `Routes.home` is currently a safety redirect to `/sitemap`
/// (see `documentation/qa/STORY-22-home-route-investigation.md`); when
/// STORY-22 reopens to ship the real `LoggedHomePage`, that ticket is
/// responsible for wrapping it with [OfflineBanner].
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({
    required this.child,
    this.message,
    super.key,
  });

  final Widget child;
  final String? message;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    if (!kResilienceLayerEnabled) {
      return child;
    }
    final status = ref.watch(connectivityStatusProvider);
    final theme = Theme.of(context);
    // Defensive lookup — if the AppLocalizations delegate is missing
    // (e.g. tests forgetting to register it), fall back to Spanish copy
    // rather than throwing inside an advisory banner.
    final l10n = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    final defaultMessage = l10n?.offlineBannerMessage ?? 'Sin conexión. Mostrando datos guardados.';
    return Column(
      children: [
        if (status == ConnectivityStatus.offline)
          Material(
            color: theme.colorScheme.errorContainer,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 18,
                      color: theme.colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        message ?? defaultMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: child),
      ],
    );
  }
}
