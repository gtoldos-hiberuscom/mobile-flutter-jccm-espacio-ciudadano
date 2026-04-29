/// Sprint 8 / STORY-65 closure — resilience kill-switch integration test.
///
/// Single integration test that exercises the OfflineBanner + connectivity
/// status path end-to-end via Riverpod overrides. The kill-switch itself
/// (`kResilienceLayerEnabled`) is a `const bool`, so it cannot be flipped
/// at runtime; instead we cover the equivalent observable contract:
///
///   1. With connectivity reporting `online`, the banner collapses to
///      zero height (no `cloud_off` icon, no banner copy rendered) and
///      the wrapped child is the only visible content. This is the
///      dominant runtime state for the resilience layer.
///   2. With connectivity reporting `offline`, the banner becomes
///      visible above the wrapped child. This proves adopters wired via
///      `OfflineBanner(child: …)` will surface the offline indicator
///      when the resilience layer is enabled (default).
///
/// If `kResilienceLayerEnabled` is ever made overridable (e.g., via a
/// runtime provider), this test should be extended with a third case
/// that flips the kill-switch off and asserts the banner stays hidden
/// even when offline.
library;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/connectivity_status.dart';
import 'package:jccm_espacio_ciudadano/core/connectivity/offline_banner.dart';
import 'package:jccm_espacio_ciudadano/core/feature_flags/resilience_flag.dart';

Widget _harness({
  required final List<ConnectivityResult> connectivity,
}) => ProviderScope(
  overrides: [
    connectivityRawStreamProvider.overrideWith(
      (final ref) => Stream<List<ConnectivityResult>>.value(connectivity),
    ),
  ],
  child: const MaterialApp(
    home: Scaffold(
      body: OfflineBanner(
        child: Center(
          key: ValueKey<String>('child-content'),
          child: Text('child-content'),
        ),
      ),
    ),
  ),
);

void main() {
  // Sanity assertion: the resilience layer is shipped enabled by default.
  // The banner only renders the indicator when this is true.
  test('kResilienceLayerEnabled defaults to true', () {
    expect(kResilienceLayerEnabled, isTrue);
  });

  testWidgets(
    'OfflineBanner stays collapsed when connectivity reports online',
    (final tester) async {
      await tester.pumpWidget(
        _harness(connectivity: const <ConnectivityResult>[
          ConnectivityResult.wifi,
        ]),
      );
      await tester.pumpAndSettle();

      // Banner widget itself is always present in the tree (it wraps
      // the child) — what must NOT be visible is the offline indicator.
      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsNothing);
      expect(find.byKey(const ValueKey<String>('child-content')), findsOneWidget);
    },
  );

  testWidgets(
    'OfflineBanner surfaces the indicator when connectivity reports offline',
    (final tester) async {
      await tester.pumpWidget(
        _harness(connectivity: const <ConnectivityResult>[
          ConnectivityResult.none,
        ]),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      // The wrapped child remains visible — the banner is advisory and
      // never replaces cached content (per OfflineBanner contract).
      expect(find.byKey(const ValueKey<String>('child-content')), findsOneWidget);
    },
  );
}
