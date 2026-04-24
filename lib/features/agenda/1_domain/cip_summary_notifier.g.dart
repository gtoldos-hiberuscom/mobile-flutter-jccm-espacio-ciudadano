// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cip_summary_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod async notifier that owns the CIP / tarjeta sanitaria
/// summary surfaced by the home salud entry point and by the agenda
/// page header (STORY-31).
///
/// ## Lifecycle
/// - On `build()`, asks the [cipRepositoryProvider] for a fresh
///   [CipSummary] and exposes it as `AsyncValue.data`.
/// - The repository encodes parse / empty / error outcomes inside the
///   summary's [CipLoadState] so the notifier stays in `data` and the
///   UI keeps partial-error tolerance (canon §16).
///
/// ## Why not keepAlive?
/// The snapshot should refresh on every navigation back so the
/// `lastUpdatedAt` stamp stays meaningful — `keepAlive: false` (the
/// default from `@riverpod`) is exactly the right semantic.

@ProviderFor(CipSummaryNotifier)
const cipSummaryProvider = CipSummaryNotifierProvider._();

/// Riverpod async notifier that owns the CIP / tarjeta sanitaria
/// summary surfaced by the home salud entry point and by the agenda
/// page header (STORY-31).
///
/// ## Lifecycle
/// - On `build()`, asks the [cipRepositoryProvider] for a fresh
///   [CipSummary] and exposes it as `AsyncValue.data`.
/// - The repository encodes parse / empty / error outcomes inside the
///   summary's [CipLoadState] so the notifier stays in `data` and the
///   UI keeps partial-error tolerance (canon §16).
///
/// ## Why not keepAlive?
/// The snapshot should refresh on every navigation back so the
/// `lastUpdatedAt` stamp stays meaningful — `keepAlive: false` (the
/// default from `@riverpod`) is exactly the right semantic.
final class CipSummaryNotifierProvider extends $AsyncNotifierProvider<CipSummaryNotifier, CipSummary> {
  /// Riverpod async notifier that owns the CIP / tarjeta sanitaria
  /// summary surfaced by the home salud entry point and by the agenda
  /// page header (STORY-31).
  ///
  /// ## Lifecycle
  /// - On `build()`, asks the [cipRepositoryProvider] for a fresh
  ///   [CipSummary] and exposes it as `AsyncValue.data`.
  /// - The repository encodes parse / empty / error outcomes inside the
  ///   summary's [CipLoadState] so the notifier stays in `data` and the
  ///   UI keeps partial-error tolerance (canon §16).
  ///
  /// ## Why not keepAlive?
  /// The snapshot should refresh on every navigation back so the
  /// `lastUpdatedAt` stamp stays meaningful — `keepAlive: false` (the
  /// default from `@riverpod`) is exactly the right semantic.
  const CipSummaryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cipSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cipSummaryNotifierHash();

  @$internal
  @override
  CipSummaryNotifier create() => CipSummaryNotifier();
}

String _$cipSummaryNotifierHash() => r'5e1173e6c4bf59cf7e2a86fec6b314ecb49eabd6';

/// Riverpod async notifier that owns the CIP / tarjeta sanitaria
/// summary surfaced by the home salud entry point and by the agenda
/// page header (STORY-31).
///
/// ## Lifecycle
/// - On `build()`, asks the [cipRepositoryProvider] for a fresh
///   [CipSummary] and exposes it as `AsyncValue.data`.
/// - The repository encodes parse / empty / error outcomes inside the
///   summary's [CipLoadState] so the notifier stays in `data` and the
///   UI keeps partial-error tolerance (canon §16).
///
/// ## Why not keepAlive?
/// The snapshot should refresh on every navigation back so the
/// `lastUpdatedAt` stamp stays meaningful — `keepAlive: false` (the
/// default from `@riverpod`) is exactly the right semantic.

abstract class _$CipSummaryNotifier extends $AsyncNotifier<CipSummary> {
  FutureOr<CipSummary> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CipSummary>, CipSummary>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<AsyncValue<CipSummary>, CipSummary>, AsyncValue<CipSummary>, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
