import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';

abstract interface class DigitalCardsRepository {
  Future<List<DigitalCard>> loadCards({required final String citizenId});

  Future<Uint8List?> loadQrImage({required final String citizenId, required final DigitalCard card});

  Future<DigitalCardArtifact> downloadQr({required final String citizenId, required final DigitalCard card});

  Future<DigitalCardArtifact> downloadPkPass({required final String citizenId, required final DigitalCard card});

  Future<DigitalCardArtifact> downloadPdf({required final String citizenId, required final DigitalCard card});
}
