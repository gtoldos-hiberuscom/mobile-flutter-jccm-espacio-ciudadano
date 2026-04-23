import 'package:jccm_espacio_ciudadano/features/external_links/0_entity/external_link.dart';

/// Reason why launching an [ExternalLink] failed.
///
/// Values are intentionally coarse-grained so they can be sent to
/// analytics without leaking PII (canon §26): no full URL, query string
/// or user-supplied content is ever attached.
enum ExternalLinkLaunchFailureReason {
  /// The URL did not pass the `https` scheme check.
  invalidScheme,

  /// The URL host did not match the catalog entry's host (open-redirect
  /// guard).
  hostMismatch,

  /// The platform refused to launch the URL (no installed handler, OS
  /// policy, etc.).
  platformRejected,

  /// Any other unexpected failure surfaced by the platform channel.
  unknown,
}

/// Outcome of attempting to launch an external link.
///
/// Implemented as a sealed hierarchy so callers must exhaustively handle
/// success and failure (canon §16, explicit screen state). No exceptions
/// cross the launcher boundary.
sealed class ExternalLinkLaunchResult {
  const ExternalLinkLaunchResult();
}

/// The launch was accepted by the platform.
///
/// "Success" here means the OS confirmed it would open the URL — the
/// app cannot observe what happens once the user is in the external
/// browser.
final class ExternalLinkLaunchSuccess extends ExternalLinkLaunchResult {
  const ExternalLinkLaunchSuccess();
}

/// The launch was rejected, either by validation or by the platform.
final class ExternalLinkLaunchFailure extends ExternalLinkLaunchResult {
  const ExternalLinkLaunchFailure(this.reason);

  /// Coarse-grained reason — safe to include in analytics payloads.
  final ExternalLinkLaunchFailureReason reason;
}

/// Domain contract responsible for opening an [ExternalLink].
///
/// Implementations belong to `3_data/` (e.g. backed by `url_launcher`).
/// They MUST validate the URL before delegating to the platform:
///   - scheme must be `https`,
///   - host must match the catalog entry's host (no open redirects).
///
/// On any failure the implementation returns an
/// [ExternalLinkLaunchFailure] instead of throwing, so call-sites can
/// surface UI feedback without try/catch noise (canon §13).
abstract interface class ExternalLinkLauncher {
  /// Attempts to open [link] in the platform's external browser.
  Future<ExternalLinkLaunchResult> launch(final ExternalLink link);
}
