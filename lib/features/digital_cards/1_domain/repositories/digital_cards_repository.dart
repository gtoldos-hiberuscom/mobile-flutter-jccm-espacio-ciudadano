import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_cards_snapshot.dart';

abstract interface class DigitalCardsRepository {
  /// Consulta los tres carnés. Devuelve los que cargaron junto con el número
  /// de consultas fallidas; lanza solo cuando TODAS fallan.
  Future<DigitalCardsSnapshot> loadCards({required final String citizenId});

  Future<Uint8List?> loadQrImage({required final String citizenId, required final DigitalCard card});

  Future<DigitalCardArtifact> downloadQr({required final String citizenId, required final DigitalCard card});

  Future<DigitalCardArtifact> downloadPkPass({required final String citizenId, required final DigitalCard card});

  Future<DigitalCardArtifact> downloadPdf({required final String citizenId, required final DigitalCard card});
}
