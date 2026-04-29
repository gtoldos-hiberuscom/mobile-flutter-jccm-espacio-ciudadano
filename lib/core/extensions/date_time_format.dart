/// Tiny pure-Dart helpers to format [DateTime] values without depending
/// on the `intl` package.
///
/// Only covers the formats actually used by the in-app surfaces — keep
/// this minimal and add new helpers explicitly when needed.
extension DateTimeFormat on DateTime {
  /// Formats the value as `dd/MM/yyyy HH:mm` in local time.
  ///
  /// Used for the agenda "última actualización" timestamp and other
  /// places where a compact, locale-neutral, machine-friendly stamp is
  /// preferable to a fully localised string.
  String formatDdMmYyyyHhMm() {
    final local = isUtc ? toLocal() : this;
    final dd = _twoDigits(local.day);
    final mm = _twoDigits(local.month);
    final yyyy = local.year.toString().padLeft(4, '0');
    final hh = _twoDigits(local.hour);
    final min = _twoDigits(local.minute);
    return '$dd/$mm/$yyyy $hh:$min';
  }

  /// Formats the value as `dd/MM/yyyy` in local time.
  String formatDdMmYyyy() {
    final local = isUtc ? toLocal() : this;
    return '${_twoDigits(local.day)}/${_twoDigits(local.month)}/'
        '${local.year.toString().padLeft(4, '0')}';
  }

  /// Formats the value as `HH:mm` in local time.
  String formatHhMm() {
    final local = isUtc ? toLocal() : this;
    return '${_twoDigits(local.hour)}:${_twoDigits(local.minute)}';
  }

  static String _twoDigits(final int value) => value.toString().padLeft(2, '0');
}
