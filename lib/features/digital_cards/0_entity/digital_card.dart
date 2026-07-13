import 'dart:typed_data';

enum DigitalCardType {
  largeFamily,
  youth,
  disability,
}

enum DigitalCardArtifactFormat { qr, pkPass, pdf }

class DigitalCardArtifact {
  const DigitalCardArtifact({
    required this.bytes,
    required this.fileName,
    required this.extension,
  });

  final Uint8List bytes;
  final String fileName;
  final String extension;
}

class DigitalCard {
  const DigitalCard({
    required this.type,
    required this.title,
    required this.number,
    required this.validFrom,
    required this.expiresAt,
    this.isDefinitive = false,
  });

  final DigitalCardType type;
  final String title;
  final String? number;
  final DateTime? validFrom;
  final DateTime? expiresAt;
  final bool isDefinitive;
}
