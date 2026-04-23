import 'package:jccm_espacio_ciudadano/features/help/0_entity/help_content.dart';

/// Domain contract for retrieving the help-center content (FAQ, guides,
/// contacts).
///
/// Implementations live in `3_data/`. Synchronous because the content is
/// bundled with the binary — no network or platform calls (canon §13).
abstract interface class HelpRepository {
  /// Returns the static help-center payload.
  HelpContent loadContent();
}
