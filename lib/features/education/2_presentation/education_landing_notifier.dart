import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jccm_espacio_ciudadano/features/education/0_entity/education_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/education/2_presentation/providers/education_repository_provider.dart';

/// Owns the Educación landing state (STORY-23). Mock-backed in Sprint 3.
class EducationLandingNotifier extends AsyncNotifier<EducationSnapshot> {
  @override
  Future<EducationSnapshot> build() => ref.watch(educationRepositoryProvider).loadSnapshot();

  Future<void> refresh() async {
    state = const AsyncValue<EducationSnapshot>.loading();
    state = await AsyncValue.guard<EducationSnapshot>(
      () => ref.read(educationRepositoryProvider).loadSnapshot(),
    );
  }
}

final educationLandingProvider = AsyncNotifierProvider<EducationLandingNotifier, EducationSnapshot>(() {
  return EducationLandingNotifier();
});
