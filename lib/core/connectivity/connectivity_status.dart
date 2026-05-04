import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sprint 7 / STORY-65 — connectivity status surface.
///
/// Lightweight wrapper over `connectivity_plus` that exposes a coarse
/// online/offline signal as a Riverpod [StreamProvider]. Features opt in
/// (e.g., agenda, notifications, recommendations) to render an offline
/// banner or to short-circuit network calls.
///
/// We intentionally collapse the multi-channel `ConnectivityResult` into a
/// boolean — features that need transport-specific UX (Wi-Fi vs. cellular)
/// can read the raw stream via [connectivityRawStreamProvider].

enum ConnectivityStatus { online, offline }

/// Maps a list of `ConnectivityResult` (the post-6.0 API) into our coarse
/// status. Online iff at least one non-`none` channel is present.
ConnectivityStatus mapConnectivityResults(
  final List<ConnectivityResult> results,
) {
  final hasReachable = results.any(
    (final r) => r != ConnectivityResult.none,
  );
  return hasReachable ? ConnectivityStatus.online : ConnectivityStatus.offline;
}

/// Raw connectivity stream — exposed for callers that need transport detail.
final Provider<Connectivity> connectivityProvider = Provider<Connectivity>(
  (final ref) => Connectivity(),
);

final StreamProvider<List<ConnectivityResult>> connectivityRawStreamProvider = StreamProvider<List<ConnectivityResult>>((final ref) async* {
  final connectivity = ref.watch(connectivityProvider);
  // Emit the current value first so listeners don't sit in `loading` until
  // the OS posts a change event.
  yield await connectivity.checkConnectivity();
  yield* connectivity.onConnectivityChanged;
});

/// Coarse online/offline status. Default value while loading: `online`.
/// We bias toward letting requests through when status is unknown rather
/// than blocking the UI prematurely (resilience is a defense-in-depth
/// layer, not a gate).
final Provider<ConnectivityStatus> connectivityStatusProvider = Provider<ConnectivityStatus>((final ref) {
  final raw = ref.watch(connectivityRawStreamProvider);
  return raw.when(
    data: mapConnectivityResults,
    loading: () => ConnectivityStatus.online,
    error: (final _, final ___) => ConnectivityStatus.online,
  );
});
