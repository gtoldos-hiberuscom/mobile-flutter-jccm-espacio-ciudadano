/// Digital cards exporters (EPIC-7 / STORY-52) — data.
library;

import 'dart:io';

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/1_domain/digital_cards_exporter_repository.dart';

/// Mock implementation of [DigitalCardsExporterRepository].
///
/// **Why a mock?** The Sprint-5 pubspec does not yet ship `path_provider`,
/// `share_plus` or `open_filex` — adding those is deferred to the
/// per-card stories that actually surface the actions on screen
/// (STORY-49 / 50 / 51). This implementation honours the full contract
/// using `Directory.systemTemp` so callers can already exercise the
/// pipeline end-to-end (write + read + sweep), and stubs the OS-level
/// gestures with `Future.value(true)` so widget tests can assert the
/// happy path.
///
/// All `// TODO(future-sprint)` markers below are the integration
/// points to swap when the real packages are wired in.
final class DigitalCardsExporterRepositoryMockImpl implements DigitalCardsExporterRepository {
  DigitalCardsExporterRepositoryMockImpl({final Directory? tempRoot}) : _tempRoot = tempRoot ?? Directory.systemTemp;

  final Directory _tempRoot;

  /// Sub-directory name within the temp root. Mirrors the value used by
  /// `lib/core/storage/temp_cleanup.dart`.
  static const String tempSubdir = 'digital_cards';

  Directory get _digitalCardsDir => Directory('${_tempRoot.path}${Platform.pathSeparator}$tempSubdir');

  @override
  Future<File> writeToTemp({
    required final List<int> bytes,
    required final String fileName,
  }) async {
    final dir = _digitalCardsDir;
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}${Platform.pathSeparator}$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  @override
  Future<bool> openExternal(
    final File file, {
    final BinaryArtifactKind? kind,
  }) async {
    // TODO(future-sprint): replace with `OpenFilex.open(file.path,
    //   type: <mime>)` once `open_filex` is added to pubspec.
    if (!file.existsSync()) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> share(final File file, {final String? subject}) async {
    // TODO(future-sprint): replace with `SharePlus.instance.share(...)`
    //   once `share_plus` is added to pubspec.
    if (!file.existsSync()) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> addToAppleWallet(final File pkpass) async {
    // TODO(future-sprint): wire a `MethodChannel('jccm/wallet')` invoking
    //   `PKAddPassesViewController` on the iOS side. The Android variant
    //   stays `false` (caller falls through to share).
    if (!Platform.isIOS) {
      return false;
    }
    if (!pkpass.existsSync()) {
      return false;
    }
    // Mock returns `false` to keep the iOS path observable in tests
    // through the controller's fallback chain. Tests that need a
    // positive Apple-Wallet result inject their own fake.
    return false;
  }

  @override
  Future<int> sweepTempCacheOlderThan(final Duration age) async {
    final dir = _digitalCardsDir;
    if (!dir.existsSync()) {
      return 0;
    }
    final cutoff = DateTime.now().subtract(age);
    var removed = 0;
    final entries = dir.listSync();
    for (final entry in entries) {
      if (entry is! File) {
        continue;
      }
      final stat = entry.statSync();
      if (stat.modified.isBefore(cutoff)) {
        try {
          entry.deleteSync();
          removed++;
        } on FileSystemException {
          // Best-effort sweep; swallow per-file errors.
        }
      }
    }
    return removed;
  }
}
