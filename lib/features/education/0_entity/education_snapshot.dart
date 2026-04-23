import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_title.dart';

/// Per-section load outcome — the landing renders each block independently
/// so a failure on one feed does not blank the whole page.
enum EducationSectionStatus { loading, loaded, empty, error }

final class EducationSection<T> {
  const EducationSection({required this.status, this.value});

  factory EducationSection.loading() =>
      const EducationSection(status: EducationSectionStatus.loading);

  factory EducationSection.loaded(final T value) =>
      EducationSection<T>(status: EducationSectionStatus.loaded, value: value);

  factory EducationSection.empty() =>
      const EducationSection(status: EducationSectionStatus.empty);

  factory EducationSection.error() =>
      const EducationSection(status: EducationSectionStatus.error);

  final EducationSectionStatus status;
  final T? value;
}

/// Aggregated payload for the Educación landing (STORY-23).
final class EducationSnapshot {
  const EducationSnapshot({
    required this.universityTitles,
    required this.nonUniversityTitles,
  });

  final EducationSection<List<EducationTitle>> universityTitles;
  final EducationSection<List<EducationTitle>> nonUniversityTitles;
}
