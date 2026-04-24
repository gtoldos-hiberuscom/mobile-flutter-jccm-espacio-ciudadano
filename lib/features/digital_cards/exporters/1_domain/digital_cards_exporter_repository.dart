/// Digital cards exporters (EPIC-7 / STORY-52) — domain.
library;

import 'dart:io';

import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact_kind.dart';

/// Abstract gateway that owns the platform-side effects of the wallet
/// pipeline: writing artifacts to a temp file, opening / sharing them
/// and (on iOS) handing PKPass bundles to PassKit.
///
/// Implementations live under `3_data/`. Tests inject fakes; the real
/// implementation is provided once `path_provider` / `share_plus` /
/// `open_filex` are added to the pubspec (see the Sprint 6 follow-ups
/// listed in STORY-52).
abstract interface class DigitalCardsExporterRepository {
  /// Persists [bytes] under `<temp>/digital_cards/<fileName>` and
  /// returns the resulting [File]. The directory is created on demand.
  Future<File> writeToTemp({
    required final List<int> bytes,
    required final String fileName,
  });

  /// Opens [file] with the system viewer (PDF / image). Returns `true`
  /// on success.
  Future<bool> openExternal(final File file, {final BinaryArtifactKind? kind});

  /// Hands [file] to the OS share sheet. Returns `true` on success.
  Future<bool> share(final File file, {final String? subject});

  /// Hands a `.pkpass` to Apple Wallet via the iOS PassKit native channel.
  /// Returns `false` when running on a non-iOS platform or when the
  /// channel is not available; never throws on the unsupported path.
  Future<bool> addToAppleWallet(final File pkpass);

  /// Sweeps the digital-cards temp cache, removing files older than
  /// [age]. Returns the count of removed files. No-op safely when the
  /// directory does not exist. Mirrors
  /// `lib/core/storage/temp_cleanup.dart` for callers that prefer
  /// going through the repository contract.
  Future<int> sweepTempCacheOlderThan(final Duration age);
}
