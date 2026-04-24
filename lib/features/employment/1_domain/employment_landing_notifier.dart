import 'package:jccm_espacio_ciudadano/features/employment/0_entity/employment_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/employment/3_data/employment_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'employment_landing_notifier.g.dart';

/// Owns the Empleo landing state (STORY-24). Mock-backed in Sprint 3.
@riverpod
class EmploymentLandingNotifier extends _$EmploymentLandingNotifier {
  @override
  Future<EmploymentSnapshot> build() => ref.watch(employmentRepositoryProvider).loadSnapshot();

  Future<void> refresh() async {
    state = const AsyncValue<EmploymentSnapshot>.loading();
    state = await AsyncValue.guard<EmploymentSnapshot>(
      () => ref.read(employmentRepositoryProvider).loadSnapshot(),
    );
  }
}
