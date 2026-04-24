/// Discriminator for the registro detail surface (STORY-36).
///
/// `entrada` covers `/publicacion/selectbynifentrada` and salida covers
/// `/publicacion/selectbynifsalida`. Both kinds funnel into
/// `/publicacion/selectbynumreg` for the detail call.
///
/// Pure-Dart enum — locale-independent and free of Flutter / Riverpod
/// imports per the architecture canon (entity layer).
enum RegistroKind { entrada, salida }

/// Wire-friendly token used in deep links for [RegistroKind].
extension RegistroKindToken on RegistroKind {
  /// Lower-case token used in route paths and analytics events.
  String get token {
    switch (this) {
      case RegistroKind.entrada:
        return 'entrada';
      case RegistroKind.salida:
        return 'salida';
    }
  }

  /// Resolves a [RegistroKind] from its [token]. Returns `null` when the
  /// input does not match a known value.
  static RegistroKind? fromToken(final String? token) {
    switch (token) {
      case 'entrada':
        return RegistroKind.entrada;
      case 'salida':
        return RegistroKind.salida;
      default:
        return null;
    }
  }
}
