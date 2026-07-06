enum DigitalCardType {
  largeFamily,
  youth,
}

class DigitalCard {
  const DigitalCard({
    required this.type,
    required this.title,
    required this.number,
    required this.expiresAt,
  });

  final DigitalCardType type;
  final String title;
  final String number;
  final DateTime? expiresAt;
}
