import 'dart:typed_data';

import 'package:jccm_espacio_ciudadano/features/digital_cards/0_entity/digital_card.dart';

abstract interface class DigitalCardsRepository {
  Future<List<DigitalCard>> loadCards({required final String documentNumber});

  Future<Uint8List?> loadQrImage({required final String documentNumber});

  Future<void> downloadQr({required final String documentNumber});

  Future<void> downloadPkPass({required final String documentNumber});

  Future<void> downloadPdf({required final String documentNumber});
}
