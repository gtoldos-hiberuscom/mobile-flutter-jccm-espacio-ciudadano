import 'package:jccm_espacio_ciudadano/features/social_welfare/0_entity/social_welfare_snapshot.dart';

/// Domain contract for the Bienestar social landing (STORY-25).
///
// TODO(STORY-25): Sprint-3 implementation returns mocked data. Real
/// wiring against `/ccaa/familia-numerosa/{numDocumento}` is owned by a
/// follow-up story.
abstract interface class SocialWelfareRepository {
  Future<SocialWelfareSnapshot> loadSnapshot();
}
