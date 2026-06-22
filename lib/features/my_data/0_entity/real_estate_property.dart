enum RealEstatePropertyKind {
  urban,
  rustic,
  unknown,
}

final class RealEstateProperty {
  const RealEstateProperty({
    this.cadastralReference,
    this.address,
    this.use,
    this.cadastralValue,
    this.landValue,
    this.constructionValue,
    this.status,
    this.cartographyUrl,
    this.holders = const [],
    this.kind = RealEstatePropertyKind.unknown,
  });

  final String? cadastralReference;
  final String? address;
  final String? use;
  final String? cadastralValue;
  final String? landValue;
  final String? constructionValue;
  final String? status;
  final String? cartographyUrl;
  final List<RealEstatePropertyHolder> holders;
  final RealEstatePropertyKind kind;

  bool get hasData => _has(cadastralReference) || _has(address) || _has(use) || _has(cadastralValue) || _has(landValue) || _has(constructionValue) || _has(status) || _has(cartographyUrl) || holders.isNotEmpty;

  static bool _has(final String? value) => value != null && value.trim().isNotEmpty;
}

final class RealEstatePropertyHolder {
  const RealEstatePropertyHolder({
    this.name,
    this.ownership,
  });

  final String? name;
  final String? ownership;

  bool get hasData => RealEstateProperty._has(name) || RealEstateProperty._has(ownership);
}
