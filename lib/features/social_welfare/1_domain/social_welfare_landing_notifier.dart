import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/social_welfare_snapshot.dart';
import 'package:jccm_espacio_ciudadano/features/social_welfare/3_data/social_welfare_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'social_welfare_landing_notifier.g.dart';

@riverpod
class SocialWelfareLandingNotifier extends _$SocialWelfareLandingNotifier {
  @override
  Future<SocialWelfareSnapshot> build() => ref.watch(socialWelfareRepositoryProvider).loadSnapshot();

  Future<void> refresh() async {
    state = const AsyncValue<SocialWelfareSnapshot>.loading();
    state = await AsyncValue.guard<SocialWelfareSnapshot>(
      () => ref.read(socialWelfareRepositoryProvider).loadSnapshot(),
    );
  }
}
