import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/3_data/education_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'education_landing_notifier.g.dart';

/// Owns the Educación landing state (STORY-23). Mock-backed in Sprint 3.
@riverpod
class EducationLandingNotifier extends _$EducationLandingNotifier {
  @override
  Future<EducationSnapshot> build() =>
      ref.watch(educationRepositoryProvider).loadSnapshot();

  Future<void> refresh() async {
    state = const AsyncValue<EducationSnapshot>.loading();
    state = await AsyncValue.guard<EducationSnapshot>(
      () => ref.read(educationRepositoryProvider).loadSnapshot(),
    );
  }
}
