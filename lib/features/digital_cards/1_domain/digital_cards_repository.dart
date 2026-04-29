import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_catalog.dart';

/// Abstract gateway for the digital cards catalogue.
///
/// Implementations live under `3_data/`. Sprint 4 ships an in-memory
/// mock; TASK-53 will wire the real `/carnet-digital/*` operations.
abstract interface class DigitalCardsRepository {
  /// Loads the current catalogue snapshot for the authenticated citizen.
  Future<DigitalCardsCatalog> loadCatalog();
}
