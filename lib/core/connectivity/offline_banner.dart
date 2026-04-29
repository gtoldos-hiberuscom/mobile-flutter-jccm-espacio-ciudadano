import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/core/feature_flags/resilience_flag.dart';

/// Sprint 7 / STORY-65 — opt-in offline banner.
///
/// Renders a slim banner above [child] when [connectivityStatusProvider]
/// reports `offline`. Features adopt by wrapping their list/inbox/feed
/// pages, e.g. agenda, notifications, recommendations.
///
/// The banner is purely advisory — adopters keep showing whatever cached
/// data they have. It does NOT replace error states; transient errors are
/// still surfaced inline by each feature.
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
                        message ??
                            'Sin conexión. Mostrando datos guardados.',
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
