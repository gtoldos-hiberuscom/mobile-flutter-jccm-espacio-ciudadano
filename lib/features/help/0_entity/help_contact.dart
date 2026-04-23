import 'package:meta/meta.dart';

/// Channel by which a [HelpContact] is reached.
enum HelpContactType { phone, email, url }

/// Immutable value object describing a contact channel shown in the
/// help center "Contacto" section.
///
/// Pure Dart only (canon §11).
@immutable
final class HelpContact {
  const HelpContact({
    required this.id,
    required this.labelKey,
    required this.value,
    required this.type,
    this.externalLinkId,
  });

  /// Stable identifier.
  final String id;

  /// ARB key for the user-facing label.
  final String labelKey;

  /// Raw value (phone number, email, or display value for url).
  ///
  /// For [HelpContactType.url] the actual launch goes through the
  /// catalog-backed external link launcher when [externalLinkId] is
  /// provided; the [value] is then a display string.
  final String value;

  final HelpContactType type;

  /// Optional reference to a catalog `ExternalLink.id` used when [type]
  /// is [HelpContactType.url] so launches go through the hardened
  /// allow-list.
  final String? externalLinkId;

  @override
  bool operator ==(final Object other) =>
      identical(this, other) ||
      other is HelpContact &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          labelKey == other.labelKey &&
          value == other.value &&
          type == other.type &&
          externalLinkId == other.externalLinkId;

  @override
  int get hashCode =>
      Object.hash(id, labelKey, value, type, externalLinkId);

  @override
  String toString() => 'HelpContact(id: $id, type: $type)';
}
