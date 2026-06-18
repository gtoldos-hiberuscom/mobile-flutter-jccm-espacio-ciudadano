class DependencyCareStatus {
  const DependencyCareStatus({
    required this.requestDate,
    required this.resolutionDate,
    required this.recognizedDegree,
    required this.baremo,
    required this.benefits,
  });

  final DateTime? requestDate;
  final DateTime? resolutionDate;
  final String recognizedDegree;
  final String baremo;
  final List<DependencyCareBenefit> benefits;
}

class DependencyCareBenefit {
  const DependencyCareBenefit({
    required this.category,
    required this.name,
    required this.resolutionDate,
    required this.effectiveDate,
    required this.amount,
  });

  final String category;
  final String name;
  final DateTime? resolutionDate;
  final DateTime? effectiveDate;
  final String amount;
}
