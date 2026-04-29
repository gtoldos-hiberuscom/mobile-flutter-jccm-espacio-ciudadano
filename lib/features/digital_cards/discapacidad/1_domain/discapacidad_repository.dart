/// Carnet Discapacidad (EPIC-7 / STORY-51) — domain.
///
/// Pure Dart contract — no Flutter / Riverpod / Dio (canon §12).
library;

import 'package:jccm_espacio_ciudadano/features/digital_cards/discapacidad/0_entity/discapacidad_card.dart';
import 'package:jccm_espacio_ciudadano/features/digital_cards/exporters/0_entity/binary_artifact.dart';

/// Abstract repository owning the lifecycle of the carnet de
/// discapacidad: load metadata + request the PKPass export.
///
/// Unlike the carnet joven (STORY-50), this carnet does **not**
/// expose QR/PDF endpoints — only PKPass when vigente. See
/// `discapacidad_repository_impl.dart` for the mock implementation
/// and the TODO with the live endpoints to wire later.
abstract interface class DiscapacidadRepository {
  /// Loads the carnet metadata for the current citizen. May throw
  /// [DiscapacidadUnavailable] when the repository determines that
  /// the citizen has no carnet at all (e.g. transport error or 404).
  ///
  /// Implementations should prefer returning a [DiscapacidadCard]
  /// with `status = notValid` or `notAvailable` rather than throwing,
  /// reserving the exception for unrecoverable conditions.
  Future<DiscapacidadCard> loadCard();

  /// Requests the PKPass bundle for the Apple Wallet pipeline.
  Future<BinaryArtifact> requestPkpass();
}

/// Thrown by [DiscapacidadRepository.loadCard] when the citizen does
/// not have a carnet (no datos / unrecoverable transport failure).
/// The page catches it and renders the explicit unavailable surface.
final class DiscapacidadUnavailable implements Exception {
  const DiscapacidadUnavailable([this.reason]);

  /// Optional opaque reason — never includes PII (canon §24).
  final String? reason;

  @override
  String toString() => 'DiscapacidadUnavailable(${reason ?? ''})';
}
