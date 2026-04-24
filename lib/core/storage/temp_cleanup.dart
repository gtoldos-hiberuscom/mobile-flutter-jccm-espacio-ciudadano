/// Cross-cutting temp-file cleanup helper (canon §17 — `lib/core/storage/`).
///
/// Used by EPIC-7 (digital cards) to sweep stale binaries from the
/// device temp directory on cold start. The function is intentionally a
/// one-shot async helper rather than a Riverpod provider — bootstrap
/// invokes it once, awaits the count, logs it (without PII) and
/// continues.
///
/// **Integration point**:
/// `lib/app/bootstrap/` should call [sweepDigitalCardsTempCache] from
/// the post-providers initialisation hook. The wiring is deliberately
/// NOT done in STORY-52 to keep the shared bootstrap untouched while
/// per-card stories (STORY-49/50/51) are still in-flight; once any of
/// them lands, the call must be added with a `// EPIC-7` marker.
///
/// Pure `dart:io` — no Flutter / Riverpod / Dio (canon §17 / §11).
library;

import 'dart:io';

/// Sub-directory under the device temp root that contains digital-card
/// binaries (PDF, PKPass, QR PNG). Mirrors
/// `DigitalCardsExporterRepositoryMockImpl.tempSubdir`.
const String _kDigitalCardsTempSubdir = 'digital_cards';

/// Sweeps `<temp>/digital_cards/`, deleting any file older than
/// [olderThan]. Returns the count of removed files; returns `0` when the
/// directory does not exist or [tempRoot] is not provided and
/// `Directory.systemTemp` cannot be resolved.
///
/// [tempRoot] defaults to `Directory.systemTemp` so the helper works
/// without `path_provider`. Bootstrap callers that already resolved
/// `getTemporaryDirectory()` should pass it in to keep the production
/// path consistent with `path_provider`.
///
/// The helper never throws; per-file errors are swallowed (best-effort).
Future<int> sweepDigitalCardsTempCache({
  final Duration olderThan = const Duration(hours: 6),
  final Directory? tempRoot,
}) async {
  final root = tempRoot ?? Directory.systemTemp;
  final dir = Directory(
    '${root.path}${Platform.pathSeparator}$_kDigitalCardsTempSubdir',
  );
  if (!dir.existsSync()) {
    return 0;
  }
  final cutoff = DateTime.now().subtract(olderThan);
  var removed = 0;
  final List<FileSystemEntity> entries;
  try {
    entries = dir.listSync();
  } on FileSystemException {
    return 0;
  }
  for (final entry in entries) {
    if (entry is! File) {
      continue;
    }
    try {
      final stat = entry.statSync();
      if (stat.modified.isBefore(cutoff)) {
        entry.deleteSync();
        removed++;
      }
    } on FileSystemException {
      // Best-effort sweep; swallow per-file errors.
    }
  }
  return removed;
}
