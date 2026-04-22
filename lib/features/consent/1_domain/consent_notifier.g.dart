// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consent_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod [AsyncNotifier] that manages the full consent lifecycle.
///
/// ## Lifecycle
/// On `build()`, reads the persisted consent status from [ConsentRepository]
/// and resolves to:
/// - [ConsentAccepted] — consent was previously given; show home directly.
/// - [ConsentPending]  — consent has not been given; show the consent screen.
///
/// ## Actions
/// - [accept]  — persists acceptance and transitions to [ConsentAccepted].
/// - [reject]  — persists rejection and transitions to [ConsentRejected].
///
/// Kept alive for the full app lifetime so the router guard always reads a
/// stable, up-to-date consent state without recreating the notifier.

@ProviderFor(ConsentNotifier)
const consentProvider = ConsentNotifierProvider._();

/// Riverpod [AsyncNotifier] that manages the full consent lifecycle.
///
/// ## Lifecycle
/// On `build()`, reads the persisted consent status from [ConsentRepository]
/// and resolves to:
/// - [ConsentAccepted] — consent was previously given; show home directly.
/// - [ConsentPending]  — consent has not been given; show the consent screen.
///
/// ## Actions
/// - [accept]  — persists acceptance and transitions to [ConsentAccepted].
/// - [reject]  — persists rejection and transitions to [ConsentRejected].
///
/// Kept alive for the full app lifetime so the router guard always reads a
/// stable, up-to-date consent state without recreating the notifier.
final class ConsentNotifierProvider
    extends $AsyncNotifierProvider<ConsentNotifier, ConsentState> {
  /// Riverpod [AsyncNotifier] that manages the full consent lifecycle.
  ///
  /// ## Lifecycle
  /// On `build()`, reads the persisted consent status from [ConsentRepository]
  /// and resolves to:
  /// - [ConsentAccepted] — consent was previously given; show home directly.
  /// - [ConsentPending]  — consent has not been given; show the consent screen.
  ///
  /// ## Actions
  /// - [accept]  — persists acceptance and transitions to [ConsentAccepted].
  /// - [reject]  — persists rejection and transitions to [ConsentRejected].
  ///
  /// Kept alive for the full app lifetime so the router guard always reads a
  /// stable, up-to-date consent state without recreating the notifier.
  const ConsentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'consentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$consentNotifierHash();

  @$internal
  @override
  ConsentNotifier create() => ConsentNotifier();
}

String _$consentNotifierHash() => r'248d7d1f0471323e948048c79da06a197507d1aa';

/// Riverpod [AsyncNotifier] that manages the full consent lifecycle.
///
/// ## Lifecycle
/// On `build()`, reads the persisted consent status from [ConsentRepository]
/// and resolves to:
/// - [ConsentAccepted] — consent was previously given; show home directly.
/// - [ConsentPending]  — consent has not been given; show the consent screen.
///
/// ## Actions
/// - [accept]  — persists acceptance and transitions to [ConsentAccepted].
/// - [reject]  — persists rejection and transitions to [ConsentRejected].
///
/// Kept alive for the full app lifetime so the router guard always reads a
/// stable, up-to-date consent state without recreating the notifier.

abstract class _$ConsentNotifier extends $AsyncNotifier<ConsentState> {
  FutureOr<ConsentState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ConsentState>, ConsentState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ConsentState>, ConsentState>,
              AsyncValue<ConsentState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
