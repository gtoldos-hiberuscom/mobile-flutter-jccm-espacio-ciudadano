import 'package:meta/meta.dart';

/// Versión semántica `major.minor.patch` de la aplicación.
///
/// Es la unidad con la que se compara lo instalado con lo publicado. El número
/// de build (`+N` en `pubspec.yaml`) se descarta a propósito: dos builds de la
/// misma versión son, a efectos del aviso de actualización, la misma versión.
@immutable
final class AppVersion implements Comparable<AppVersion> {
  const AppVersion(this.major, this.minor, this.patch) : assert(major >= 0 && minor >= 0 && patch >= 0, 'Version components must be non-negative');

  /// Parsea `x.y.z` o `x.y.z+build`.
  ///
  /// Cualquier otra forma (dos componentes, letras, vacío) lanza
  /// [FormatException]: un manifiesto mal formado debe fallar, no adivinarse.
  factory AppVersion.parse(final String raw) {
    final match = _pattern.firstMatch(raw.trim().split('+').first);
    if (match == null) {
      throw FormatException('Invalid app version', raw);
    }
    return AppVersion(int.parse(match[1]!), int.parse(match[2]!), int.parse(match[3]!));
  }

  final int major;
  final int minor;
  final int patch;

  static final RegExp _pattern = RegExp(r'^(\d+)\.(\d+)\.(\d+)$');

  /// Como [AppVersion.parse], pero devuelve `null` en vez de lanzar.
  static AppVersion? tryParse(final String? raw) {
    if (raw == null) {
      return null;
    }
    try {
      return AppVersion.parse(raw);
    } on FormatException {
      return null;
    }
  }

  @override
  int compareTo(final AppVersion other) {
    if (major != other.major) {
      return major.compareTo(other.major);
    }
    if (minor != other.minor) {
      return minor.compareTo(other.minor);
    }
    return patch.compareTo(other.patch);
  }

  bool operator <(final AppVersion other) => compareTo(other) < 0;

  bool operator <=(final AppVersion other) => compareTo(other) <= 0;

  bool operator >(final AppVersion other) => compareTo(other) > 0;

  bool operator >=(final AppVersion other) => compareTo(other) >= 0;

  @override
  bool operator ==(final Object other) => identical(this, other) || other is AppVersion && runtimeType == other.runtimeType && major == other.major && minor == other.minor && patch == other.patch;

  @override
  int get hashCode => Object.hash(major, minor, patch);

  @override
  String toString() => '$major.$minor.$patch';
}
