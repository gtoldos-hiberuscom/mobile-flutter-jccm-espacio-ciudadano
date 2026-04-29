import 'package:jccm_espacio_ciudadano/features/personalization/0_entity/data_consent.dart';

/// Lifecycle of the data-consent screen (STORY-55).
///
/// `initial` is emitted before the first load completes; `loaded` covers the
/// idle interactive state; `saving` and `saved` are short-lived transitions
/// triggered by the explicit save / revoke actions; `error` covers both load
/// and persistence failures (the notifier exposes the originating action
/// through [DataConsentSnapshot.errorMessage]); `empty` is reserved for the
/// case where the backend returns no clausulas.
enum DataConsentLoadState {
  initial,
  loading,
  loaded,
  saving,
  saved,
  error,
  empty,
}

/// Immutable snapshot exposed by the data-consent notifier.
///
/// Holds the catalog of [items] (one entry per [DataConsentType]), the
/// citizen's draft acceptance per consent id, the baseline (last persisted)
/// acceptance map used to detect dirty state, and the lifecycle [state].
/// Pure Dart on purpose — no Flutter, no Riverpod, no infrastructure
/// imports.
final class DataConsentSnapshot {
  const DataConsentSnapshot({
    required this.items,
    required this.draft,
    required this.baseline,
    required this.state,
    this.errorMessage,
  });

  /// Initial empty value used by the notifier before the first load.
  factory DataConsentSnapshot.initial() => const DataConsentSnapshot(
    items: <DataConsent>[],
    draft: <String, bool>{},
    baseline: <String, bool>{},
    state: DataConsentLoadState.initial,
  );

  final List<DataConsent> items;

  /// Current (possibly unsaved) acceptance flag indexed by consent id.
  final Map<String, bool> draft;

  /// Last persisted acceptance flag indexed by consent id.
  final Map<String, bool> baseline;

  final DataConsentLoadState state;
  final String? errorMessage;

  /// Whether the current draft differs from the persisted baseline.
  bool get isDirty {
    if (draft.length != baseline.length) {
      return true;
    }
    for (final entry in draft.entries) {
      if (baseline[entry.key] != entry.value) {
        return true;
      }
    }
    return false;
  }

  bool isAccepted(final String id) => draft[id] ?? false;

  DataConsentSnapshot copyWith({
    final List<DataConsent>? items,
    final Map<String, bool>? draft,
    final Map<String, bool>? baseline,
    final DataConsentLoadState? state,
    final String? errorMessage,
    final bool clearError = false,
  }) {
    return DataConsentSnapshot(
      items: items ?? this.items,
      draft: draft ?? this.draft,
      baseline: baseline ?? this.baseline,
      state: state ?? this.state,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
