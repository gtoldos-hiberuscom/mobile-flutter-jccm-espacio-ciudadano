import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';

/// Resultado de consultar los carnés: los que cargaron y cuántas consultas
/// fallaron. Antes un fallo parcial se tragaba en silencio y el ciudadano
/// veía un listado incompleto presentado como completo.
final class DigitalCardsSnapshot {
  const DigitalCardsSnapshot({
    required this.cards,
    required this.failedCount,
  });

  final List<DigitalCard> cards;
  final int failedCount;

  bool get hasPartialFailures => failedCount > 0 && cards.isNotEmpty;
}
