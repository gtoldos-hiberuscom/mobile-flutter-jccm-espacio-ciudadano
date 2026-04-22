/// Pure Dart entity — no Flutter, no Riverpod, no infrastructure imports.
class UserProfile {
  const UserProfile({
    required this.idAgente,
    this.displayName,
    this.email,
  });

  final String idAgente;
  final String? displayName;
  final String? email;

  /// Returns the first character of [displayName] (or [idAgente]) uppercased.
  String get initials =>
      (displayName ?? idAgente).substring(0, 1).toUpperCase();
}
