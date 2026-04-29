import 'package:jccm_espacio_ciudadano/core/analytics/analytics_event.dart';
import 'package:jccm_espacio_ciudadano/core/analytics/analytics_service.dart';
import 'package:jccm_espacio_ciudadano/core/logging/app_logger.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_catalog.dart';
import 'package:jccm_espacio_ciudadano/features/external_links/1_domain/external_link_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

/// Signature for the platform launch primitive.
///
/// Mirrors `package:url_launcher`'s `launchUrl` so tests can substitute a
/// fake without depending on the real plugin (canon §27, testable seams).
typedef LaunchUrlFn =
    Future<bool> Function(
      Uri url, {
      LaunchMode mode,
    });

/// `url_launcher`-backed implementation of [ExternalLinkLauncher].
///
/// Hardening (canon §24, security annex):
/// - Scheme must be exactly `https`.
/// - Host must match a known catalog entry (open-redirect guard).
///   Even if the [ExternalLink] passed in is well-formed, we re-resolve
///   the host against [ExternalLinkCatalog] to defend against a caller
///   that constructs an `ExternalLink` outside the catalog.
/// - The full URL is **never** logged or sent to analytics; only the
///   stable [ExternalLink.id] and the host are referenced (canon §26).
/// - Failures are returned as [ExternalLinkLaunchFailure]; nothing is
///   thrown across the boundary.
final class UrlLauncherExternalLinkLauncher implements ExternalLinkLauncher {
  const UrlLauncherExternalLinkLauncher({
    required final ExternalLinkCatalog catalog,
    required final AnalyticsService analytics,
    required final AppLogger logger,
    final LaunchUrlFn launchUrlFn = launchUrl,
  }) : _catalog = catalog,
       _analytics = analytics,
       _logger = logger,
       _launchUrlFn = launchUrlFn;

  final ExternalLinkCatalog _catalog;
  final AnalyticsService _analytics;
  final AppLogger _logger;
  final LaunchUrlFn _launchUrlFn;

  @override
  Future<ExternalLinkLaunchResult> launch(final ExternalLink link) async {
    // 1. Scheme must be HTTPS.
    if (link.url.scheme != 'https') {
      return _failure(link, ExternalLinkLaunchFailureReason.invalidScheme);
    }

    // 2. Host must match a known catalog entry (open-redirect guard).
    final ExternalLink? canonical = _catalog.findById(link.id);
    if (canonical == null || canonical.url.host != link.url.host) {
      return _failure(link, ExternalLinkLaunchFailureReason.hostMismatch);
    }

    // 3. Delegate to the platform.
    try {
      final bool accepted = await _launchUrlFn(
        link.url,
        mode: LaunchMode.externalApplication,
      );
      if (!accepted) {
        return _failure(
          link,
          ExternalLinkLaunchFailureReason.platformRejected,
        );
      }
    } on Object catch (error, stackTrace) {
      _logger.error(
        '[external_links] platform launch threw',
        exception: error,
        stackTrace: stackTrace,
      );
      return _failure(link, ExternalLinkLaunchFailureReason.unknown);
    }

    _analytics
      ..logEvent(ExternalLinkOpenedEvent(linkId: link.id, success: true))
      // Backwards-compatible domain-only event also emitted so existing
      // consumers (canon §26 inventory) keep working.
      ..logEvent(ExternalLinkEvent(link.url.host));
    return const ExternalLinkLaunchSuccess();
  }

  ExternalLinkLaunchFailure _failure(
    final ExternalLink link,
    final ExternalLinkLaunchFailureReason reason,
  ) {
    _analytics
      ..logEvent(ExternalLinkOpenedEvent(linkId: link.id, success: false))
      ..logEvent(
        ExternalLinkOpenFailedEvent(linkId: link.id, reason: reason.name),
      );
    return ExternalLinkLaunchFailure(reason);
  }
}
