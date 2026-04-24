/// Digital cards exporters (EPIC-7 / STORY-52) — pure-Dart entity.
library;

/// Wallet capability supported by the platform / runtime.
///
/// The presentation layer uses these flags to gate the action bar.
enum WalletCapability {
  /// iOS PassKit add-pass dialog. Only available on iOS.
  appleWallet,

  /// Google Wallet "Add to Wallet" button. Requires a Google-signed JWT
  /// from the backend; not adopted in MVP. Present here for future use.
  googleWallet,

  /// Cross-platform share sheet (`share_plus` / OS chooser). Always available.
  shareFallback,

  /// Open with the system viewer (`open_filex` / OS handler). Available
  /// when a viewer is registered for the file MIME.
  openExternal,
}
