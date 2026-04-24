/// Type of identification document accepted by the aportación wizard
/// (STORY-37).
///
/// Locale-independent. Format validation is enforced in
/// [InterestedPartyIdentification.isValid].
enum InterestedPartyIdType { nif, nie, passport, cif }

/// Immutable identification of the interested party for the third-party
/// aportación flow (STORY-37). Pure Dart — no Flutter, no Riverpod.
final class InterestedPartyIdentification {
  const InterestedPartyIdentification({
    required this.idType,
    required this.idNumber,
  });

  final InterestedPartyIdType idType;
  final String idNumber;

  /// Returns the identification number trimmed and uppercased — the
  /// canonical form used to drive repository look-ups.
  String get normalizedNumber => idNumber.trim().toUpperCase();

  /// Validates [idNumber] against the format rules for [idType].
  ///
  ///   - NIF: 8 digits + 1 letter (`[0-9]{8}[A-Z]`).
  ///   - NIE: leading X/Y/Z + 7 digits + 1 letter (`[XYZ][0-9]{7}[A-Z]`).
  ///   - passport: 6-9 alphanumeric characters (`[A-Z0-9]{6,9}`).
  ///   - CIF: 1 letter + 7 digits + 1 alphanumeric control
  ///     (`[A-HJNP-SUVW][0-9]{7}[0-9A-J]`).
  bool isValid() {
    final value = normalizedNumber;
    if (value.isEmpty) {
      return false;
    }
    switch (idType) {
      case InterestedPartyIdType.nif:
        return _nif.hasMatch(value);
      case InterestedPartyIdType.nie:
        return _nie.hasMatch(value);
      case InterestedPartyIdType.passport:
        return _passport.hasMatch(value);
      case InterestedPartyIdType.cif:
        return _cif.hasMatch(value);
    }
  }

  static final RegExp _nif = RegExp(r'^[0-9]{8}[A-Z]$');
  static final RegExp _nie = RegExp(r'^[XYZ][0-9]{7}[A-Z]$');
  static final RegExp _passport = RegExp(r'^[A-Z0-9]{6,9}$');
  static final RegExp _cif = RegExp(r'^[A-HJNP-SUVW][0-9]{7}[0-9A-J]$');
}
