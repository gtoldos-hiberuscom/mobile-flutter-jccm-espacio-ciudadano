/// DTO for the userinfo claims returned by the Cl@ve userinfo endpoint.
///
/// Stays in `3_data/` — never exposed outside the data layer.
final class ClaveUserInfoDto {
  const ClaveUserInfoDto({
    required this.sub,
    required this.claims,
    this.nif,
    this.givenName,
    this.familyName,
    this.email,
  });

  factory ClaveUserInfoDto.fromJson(final Map<String, dynamic> json) {
    return ClaveUserInfoDto(
      sub: _string(json['sub']) ?? '',
      nif: _string(json['nif']) ?? _string(json['idAgente']),
      givenName: _string(json['given_name']),
      familyName: _string(json['family_name']),
      email: _string(json['email']),
      claims: Map<String, dynamic>.unmodifiable(json),
    );
  }

  final String sub;
  final String? nif;
  final String? givenName;
  final String? familyName;
  final String? email;
  final Map<String, dynamic> claims;

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
    return 'ClaveUserInfoDto('
        'hasSub: ${sub.isNotEmpty}, '
        'hasNif: ${nif != null}, '
        'hasDisplayName: ${displayName != null}, '
        'hasEmail: ${email != null}'
        ')';
  }

  static String? _string(final Object? value) {
    if (value is! String) {
      return null;
    }

    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
