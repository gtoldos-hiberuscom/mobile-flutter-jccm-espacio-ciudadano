class LargeFamilyTitle {
  const LargeFamilyTitle({
    required this.region,
    required this.titleNumber,
    required this.category,
    required this.isValid,
    required this.issueDate,
    required this.expiryDate,
    required this.childrenCount,
    required this.beneficiaries,
  });

  final String region;
  final String titleNumber;
  final String category;
  final bool isValid;
  final DateTime? issueDate;
  final DateTime? expiryDate;
  final int? childrenCount;
  final List<LargeFamilyBeneficiary> beneficiaries;
}

class LargeFamilyBeneficiary {
  const LargeFamilyBeneficiary({
    required this.documentNumber,
    required this.birthDate,
    required this.fullName,
    required this.isHolder,
  });

  final String documentNumber;
  final DateTime? birthDate;
  final String fullName;
  final bool isHolder;
}
