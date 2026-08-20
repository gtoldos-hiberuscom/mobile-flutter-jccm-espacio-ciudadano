/// Convierte las fechas y horas que devuelve el SESCAM en un [DateTime].
///
/// El gateway informa `fecha` como `dd/MM/yyyy` y `hora` como `HH:mm`, pero la
/// fachada ha devuelto históricamente también valores ISO y campos combinados,
/// así que se aceptan ambas formas.
DateTime? parseSescamDateTime(final String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }
  final trimmed = value.trim();

  final iso = DateTime.tryParse(trimmed);
  if (iso != null) {
    return iso;
  }

  final match = RegExp(r'^(\d{1,2})[/-](\d{1,2})[/-](\d{4})(?:\s+(\d{1,2}):(\d{2}))?').firstMatch(trimmed);
  if (match == null) {
    return null;
  }

  final day = int.tryParse(match.group(1)!);
  final month = int.tryParse(match.group(2)!);
  final year = int.tryParse(match.group(3)!);
  final hour = int.tryParse(match.group(4) ?? '0');
  final minute = int.tryParse(match.group(5) ?? '0');
  if (day == null || month == null || year == null || hour == null || minute == null) {
    return null;
  }

  return DateTime(year, month, day, hour, minute);
}

/// Combina los campos `fecha` y `hora` en un único [DateTime].
DateTime? parseSescamDateAndTime({required final String? date, required final String? time}) {
  if (date == null || date.trim().isEmpty) {
    return null;
  }
  final normalizedTime = time?.trim();
  final hasTime = normalizedTime != null && normalizedTime.isNotEmpty;
  return parseSescamDateTime('${date.trim()} ${hasTime ? normalizedTime : '00:00'}') ?? parseSescamDateTime(date);
}
