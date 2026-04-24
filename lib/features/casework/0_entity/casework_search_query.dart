/// Identifies which of the three independent inputs the user filled in
/// for a casework search (STORY-39).
///
/// Locale-independent — UI labels are resolved through l10n in the
/// presentation layer.
enum CaseworkSearchField {
  /// Identification document — NIF, NIE or pasaporte.
  identification,

  /// Administrative file number (número de expediente).
  expedienteNumber,

  /// Registry entry/exit number (número de registro).
  registroNumber,
}

/// Reason why a casework search query is invalid.
///
/// Returned per-field by [CaseworkSearchQuery.validate] so the
/// presentation layer can map each reason to a localized message.
enum CaseworkSearchValidationError {
  /// No input was provided in any of the three fields.
  noInputProvided,

  /// The identification value does not match NIF, NIE or pasaporte.
  invalidIdentification,

  /// The expediente or registro number contains forbidden characters.
  invalidNumberFormat,
}

/// Result of validating a [CaseworkSearchQuery].
///
/// Aggregates field-level errors and the overall "at least one input is
/// required" constraint. A valid query is one where [errors] is empty
/// and [generalError] is null.
final class CaseworkSearchValidation {
  const CaseworkSearchValidation({
    this.generalError,
    this.errors = const <CaseworkSearchField, CaseworkSearchValidationError>{},
  });

  /// "At least one input is required" — independent of fields.
  final CaseworkSearchValidationError? generalError;

  /// Per-field format errors. Empty when every filled-in field is valid.
  final Map<CaseworkSearchField, CaseworkSearchValidationError> errors;

  /// True when the query can be safely executed.
  bool get isValid => generalError == null && errors.isEmpty;
}

/// Immutable casework search inputs (STORY-39).
///
/// All three values are independent and any combination is allowed at the
/// type level — business rules are enforced via [validate].
///
/// Format rules (canon Annex B / domain layer):
///   - identification: NIF (`[0-9]{8}[A-Z]`),
///                     NIE (`[XYZ][0-9]{7}[A-Z]`),
///                     pasaporte (`[A-Z0-9]{6,9}`).
///   - expediente / registro: non-empty, only `[A-Za-z0-9-/]` characters.
///
/// Pure Dart — no Flutter, Riverpod or infrastructure imports.
final class CaseworkSearchQuery {
  const CaseworkSearchQuery({
    this.identification = '',
    this.expedienteNumber = '',
    this.registroNumber = '',
  });

  /// Empty query — initial state.
  static const CaseworkSearchQuery empty = CaseworkSearchQuery();

  final String identification;
  final String expedienteNumber;
  final String registroNumber;

  /// Returns the trimmed value for a given field.
  String valueFor(final CaseworkSearchField field) {
    switch (field) {
      case CaseworkSearchField.identification:
        return identification.trim();
      case CaseworkSearchField.expedienteNumber:
        return expedienteNumber.trim();
      case CaseworkSearchField.registroNumber:
        return registroNumber.trim();
    }
  }

  /// Returns the first non-empty field in declaration order, or null when
  /// the query is empty.
  CaseworkSearchField? get firstFilledField {
    for (final field in CaseworkSearchField.values) {
      if (valueFor(field).isNotEmpty) {
        return field;
      }
    }
    return null;
  }

  CaseworkSearchQuery copyWith({
    final String? identification,
    final String? expedienteNumber,
    final String? registroNumber,
  }) => CaseworkSearchQuery(
    identification: identification ?? this.identification,
    expedienteNumber: expedienteNumber ?? this.expedienteNumber,
    registroNumber: registroNumber ?? this.registroNumber,
  );

  /// Validates the query against the format rules described in the class
  /// docstring.
  CaseworkSearchValidation validate() {
    final filled = firstFilledField;
    if (filled == null) {
      return const CaseworkSearchValidation(
        generalError: CaseworkSearchValidationError.noInputProvided,
      );
    }

    final errors = <CaseworkSearchField, CaseworkSearchValidationError>{};

    final id = valueFor(CaseworkSearchField.identification);
    if (id.isNotEmpty && !_isValidIdentification(id)) {
      errors[CaseworkSearchField.identification] = CaseworkSearchValidationError.invalidIdentification;
    }

    final exp = valueFor(CaseworkSearchField.expedienteNumber);
    if (exp.isNotEmpty && !_isValidNumber(exp)) {
      errors[CaseworkSearchField.expedienteNumber] = CaseworkSearchValidationError.invalidNumberFormat;
    }

    final reg = valueFor(CaseworkSearchField.registroNumber);
    if (reg.isNotEmpty && !_isValidNumber(reg)) {
      errors[CaseworkSearchField.registroNumber] = CaseworkSearchValidationError.invalidNumberFormat;
    }

    return CaseworkSearchValidation(errors: errors);
  }

  /// Returns the field that should drive the search call once the query
  /// is valid: identification → expediente → registro precedence.
  CaseworkSearchField? get effectiveField {
    final v = validate();
    if (!v.isValid) {
      return null;
    }
    return firstFilledField;
  }

  static final RegExp _nif = RegExp(r'^[0-9]{8}[A-Z]$');
  static final RegExp _nie = RegExp(r'^[XYZ][0-9]{7}[A-Z]$');
  static final RegExp _passport = RegExp(r'^[A-Z0-9]{6,9}$');
  static final RegExp _number = RegExp(r'^[A-Za-z0-9\-/]+$');

  static bool _isValidIdentification(final String value) {
    final upper = value.toUpperCase();
    return _nif.hasMatch(upper) || _nie.hasMatch(upper) || _passport.hasMatch(upper);
  }

  static bool _isValidNumber(final String value) => _number.hasMatch(value);
}
