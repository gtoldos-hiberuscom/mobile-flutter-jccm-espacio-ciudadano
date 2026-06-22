final class HousingAddress {
  const HousingAddress({
    this.address,
    this.postalCode,
    this.municipality,
    this.province,
    this.collectiveEntity,
    this.singleEntity,
    this.populationUnit,
    this.variationType,
    this.variationDate,
  });

  final String? address;
  final String? postalCode;
  final String? municipality;
  final String? province;
  final String? collectiveEntity;
  final String? singleEntity;
  final String? populationUnit;
  final String? variationType;
  final DateTime? variationDate;

  bool get hasData => _hasText(address) || _hasText(postalCode) || _hasText(municipality) || _hasText(province) || _hasText(collectiveEntity) || _hasText(singleEntity) || _hasText(populationUnit) || _hasText(variationType) || variationDate != null;

  static bool _hasText(final String? value) => value != null && value.trim().isNotEmpty;
}
