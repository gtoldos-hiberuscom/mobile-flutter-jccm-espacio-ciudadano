final class EmploymentDemand {
  const EmploymentDemand({
    this.status,
    this.uninterruptedRegistrationDate,
    this.message,
  });

  final String? status;
  final DateTime? uninterruptedRegistrationDate;
  final String? message;

  bool get hasData => _has(status) || uninterruptedRegistrationDate != null || _has(message);

  static bool _has(final String? value) => value != null && value.trim().isNotEmpty;
}
