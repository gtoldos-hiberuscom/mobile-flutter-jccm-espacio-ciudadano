/// Tipo de documento que declaran los contratos de intermediación y educación:
/// `NIF`, `NIE` o `CIF`.
///
/// Se deduce del propio número porque el token no informa el tipo de forma
/// fiable: las personas físicas extranjeras empiezan por X, Y o Z, y las
/// jurídicas por una letra de la A a la W.
String documentTypeOf(final String documentNumber) {
  final normalized = documentNumber.trim().toUpperCase();
  if (normalized.isEmpty) {
    return 'NIF';
  }
  final first = normalized[0];
  if (first == 'X' || first == 'Y' || first == 'Z') {
    return 'NIE';
  }
  return RegExp(r'^[A-W]$').hasMatch(first) ? 'CIF' : 'NIF';
}
