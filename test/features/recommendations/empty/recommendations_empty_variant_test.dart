import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_config_state.dart';
import 'package:jccm_espacio_ciudadano/features/recommendations/0_entity/recommendations_empty_variant.dart';

void main() {
  group('RecommendationsEmptyVariant.from', () {
    final cases = <_Case>[
      _Case(
        config: RecommendationsConfigState.unconfigured,
        bucketHasItems: false,
        expected: RecommendationsEmptyVariant.unconfigured,
      ),
      _Case(
        config: RecommendationsConfigState.unconfigured,
        bucketHasItems: true,
        expected: RecommendationsEmptyVariant.unconfigured,
      ),
      _Case(
        config: RecommendationsConfigState.unauthorised,
        bucketHasItems: false,
        expected: RecommendationsEmptyVariant.unauthorised,
      ),
      _Case(
        config: RecommendationsConfigState.unauthorised,
        bucketHasItems: true,
        expected: RecommendationsEmptyVariant.unauthorised,
      ),
      _Case(
        config: RecommendationsConfigState.configured,
        bucketHasItems: false,
        expected: RecommendationsEmptyVariant.configuredButEmpty,
      ),
      _Case(
        config: RecommendationsConfigState.configured,
        bucketHasItems: true,
        expected: RecommendationsEmptyVariant.configuredButEmpty,
      ),
    ];

    for (final c in cases) {
      test(
        'config=${c.config.name} hasItems=${c.bucketHasItems} → ${c.expected.name}',
        () {
          expect(
            RecommendationsEmptyVariant.from(
              config: c.config,
              bucketHasItems: c.bucketHasItems,
            ),
            c.expected,
          );
        },
      );
    }
  });
}

class _Case {
  _Case({
    required this.config,
    required this.bucketHasItems,
    required this.expected,
  });
  final RecommendationsConfigState config;
  final bool bucketHasItems;
  final RecommendationsEmptyVariant expected;
}
