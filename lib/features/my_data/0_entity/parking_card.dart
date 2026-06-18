class ParkingCard {
  const ParkingCard({
    required this.cardCode,
    required this.modality,
    required this.validFrom,
    required this.validUntil,
  });

  final String cardCode;
  final String modality;
  final DateTime? validFrom;
  final DateTime? validUntil;
}
