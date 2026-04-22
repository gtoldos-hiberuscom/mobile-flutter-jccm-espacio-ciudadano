/// Contact information entry shown in the Help → Contacto tab.
///
/// Entities are pure Dart — no Flutter, Riverpod, or infrastructure imports.
library;

/// The type of contact channel, used to pick the icon and URI scheme.
enum ContactType {
  /// A telephone number — launches `tel:` URI.
  phone,

  /// An e-mail address — launches `mailto:` URI.
  email,

  /// A web URL — launches the external browser.
  url,
}

/// A single contact channel displayed in the contact list.
final class ContactInfo {
  const ContactInfo({
    required this.label,
    required this.value,
    required this.type,
  });

  /// Human-readable label for the contact channel (e.g. "Atención ciudadana").
  final String label;

  /// The actual contact value: a phone number, email address, or URL string.
  final String value;

  /// Classifies the channel so the UI can choose the correct icon and action.
  final ContactType type;
}
