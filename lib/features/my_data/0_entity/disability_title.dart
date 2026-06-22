class DisabilityTitle {
  const DisabilityTitle({
    required this.degreePercent,
    required this.effectiveDate,
    required this.hasPermanentValidity,
    required this.fileNumber,
    required this.birthDate,
    required this.hasReducedMobility,
    required this.hasThirdPersonAssistance,
    required this.royalDecree,
  });

  final int? degreePercent;
  final DateTime? effectiveDate;
  final bool? hasPermanentValidity;
  final String fileNumber;
  final DateTime? birthDate;
  final bool? hasReducedMobility;
  final bool? hasThirdPersonAssistance;
  final String royalDecree;
}
