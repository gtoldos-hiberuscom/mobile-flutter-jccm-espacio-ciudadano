import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/family_numerosa_title.dart';

enum SocialWelfareSectionStatus { loading, loaded, empty, error }

final class SocialWelfareSection<T> {
  const SocialWelfareSection({required this.status, this.value});
  factory SocialWelfareSection.loading() => const SocialWelfareSection(status: SocialWelfareSectionStatus.loading);
  factory SocialWelfareSection.loaded(final T value) => SocialWelfareSection<T>(
    status: SocialWelfareSectionStatus.loaded,
    value: value,
  );
  factory SocialWelfareSection.empty() => const SocialWelfareSection(status: SocialWelfareSectionStatus.empty);
  factory SocialWelfareSection.error() => const SocialWelfareSection(status: SocialWelfareSectionStatus.error);
  final SocialWelfareSectionStatus status;
  final T? value;
}

/// Aggregated payload for the Bienestar social landing (STORY-25).
final class SocialWelfareSnapshot {
  const SocialWelfareSnapshot({required this.familyNumerosa});

  final SocialWelfareSection<FamilyNumerosaTitle> familyNumerosa;
}
