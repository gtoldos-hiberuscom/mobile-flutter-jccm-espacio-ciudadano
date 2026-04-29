/// Domain abstraction over the OS-level URL launcher used for the
/// external signature handoff (STORY-46).
///
/// Pure interface — no Flutter, no `package:url_launcher`, no
/// `BuildContext`. The concrete implementation lives in `3_data/`
/// (`UrlLauncherSignatureHandoffLauncher`).
///
/// Implementations must return `false` (instead of throwing) when the
/// platform refuses to handle the URI, so the controller can transition
/// to the `error` outcome without leaking infrastructure exceptions.
abstract class SignatureHandoffLauncher {
  /// Opens [externalUri] in an external application (typically the
  /// system browser or the Afirma client).
  ///
  /// Returns `true` when the OS accepted the launch request, `false`
  /// otherwise. Must not throw under normal operation.
  Future<bool> launchExternal(final Uri externalUri);
}
