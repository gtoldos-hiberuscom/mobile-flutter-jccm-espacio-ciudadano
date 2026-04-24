/// Load outcome for the [CipSummary] payload.
///
/// Mirrors the partial-error tolerance pattern of `AgendaLoadState`
/// (canon §16). The notifier never enters `AsyncValue.error` for an
/// unparseable CIP — instead the snapshot itself carries [parseError]
/// so the UI can render a tonal recoverable surface inline (STORY-31).
enum CipLoadState { loading, loaded, empty, parseError, error }

/// Pure-Dart value object that surfaces the citizen's CIP / tarjeta
/// sanitaria as a "destacado dato de salud" on both the agenda and the
/// home dashboard (STORY-31).
///
/// Per the TASK-71 surface decision (CIP_REUSE), this snapshot is the
/// single source of truth for the read-only CIP rendering. No PKPass /
/// QR / PDF actions are derived from it and there is no wallet-style
/// semantic — the same payload is reused by the home salud entry point
/// and by the agenda detail header so both surfaces stay in sync.
///
/// No Flutter / Riverpod / DTO leakage allowed (canon §11, 0_entity).
final class CipSummary {
  const CipSummary({
    required this.id,
    required this.cipCode,
    required this.lastUpdatedAt,
    required this.loadState,
    this.titular,
    this.centroSalud,
    this.region,
    this.parseErrorReason,
  });

  /// Empty placeholder snapshot used while the notifier is still loading.
  factory CipSummary.empty() => CipSummary(
    id: '',
    cipCode: '',
    lastUpdatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    loadState: CipLoadState.loading,
  );

  /// Stable identifier for analytics / instrumentation. Never PII.
  final String id;

  /// CIP code as rendered on the tarjeta sanitaria. Treated as opaque
  /// by the UI — copy-to-clipboard is the only affordance per TASK-71.
  final String cipCode;

  /// Optional cardholder display name, surfaced under the CIP code.
  final String? titular;

  /// Optional health centre ("centro de salud") attached to the CIP.
  final String? centroSalud;

  /// Optional health region ("región sanitaria") metadata.
  final String? region;

  /// Timestamp of the last successful refresh.
  final DateTime lastUpdatedAt;

  /// Load outcome — drives which sub-surface the card renders.
  final CipLoadState loadState;

  /// Optional locale-independent reason associated with
  /// [CipLoadState.parseError]. Mapped to a localised message by the UI
  /// (canon §24, never expose raw payload data).
  final String? parseErrorReason;
}
