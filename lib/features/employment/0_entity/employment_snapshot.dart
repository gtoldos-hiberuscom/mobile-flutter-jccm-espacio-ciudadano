import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_seeker_status.dart';

enum EmploymentSectionStatus { loading, loaded, empty, error }

final class EmploymentSection<T> {
  const EmploymentSection({required this.status, this.value});
  factory EmploymentSection.loading() =>
      const EmploymentSection(status: EmploymentSectionStatus.loading);
  factory EmploymentSection.loaded(final T value) =>
      EmploymentSection<T>(status: EmploymentSectionStatus.loaded, value: value);
  factory EmploymentSection.empty() =>
      const EmploymentSection(status: EmploymentSectionStatus.empty);
  factory EmploymentSection.error() =>
      const EmploymentSection(status: EmploymentSectionStatus.error);
  final EmploymentSectionStatus status;
  final T? value;
}

/// Aggregated payload for the Empleo landing (STORY-24).
final class EmploymentSnapshot {
  const EmploymentSnapshot({required this.seekerStatus});

  final EmploymentSection<EmploymentSeekerStatus> seekerStatus;
}
