/// Represents the authenticated citizen's identity claims.
final class AuthUser {
  const AuthUser({
    required this.sub,
    this.nif,
    this.givenName,
    this.familyName,
    this.email,
  });

  final String sub;
  final String? nif;
  final String? givenName;
  final String? familyName;
  final String? email;

  /// Returns the document identifier (`nif`) when available, falling back to `sub`.
  String get idAgente => nif ?? sub;

  String? get displayName {
    final names = [
      givenName?.trim(),
      familyName?.trim(),
    ].whereType<String>().where((final value) => value.isNotEmpty);

    final display = names.join(' ');
    if (display.isEmpty) {
      return null;
    }
    return display;
  }

  @override
  String toString() {
    return 'AuthUser('
        'hasSub: ${sub.isNotEmpty}, '
        'hasNif: ${nif != null}, '
        'hasDisplayName: ${displayName != null}, '
        'hasEmail: ${email != null}'
        ')';
  }
}
